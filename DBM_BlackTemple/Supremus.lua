local Supremus = DBM:NewBossMod("Supremus", DBM_SUPREMUS_NAME, DBM_SUPREMUS_DESCRIPTION, DBM_BLACK_TEMPLE, DBM_BT_TAB, 2);

Supremus.Version	= "1.1";
Supremus.Author		= "LYQ";
Supremus.MinRevision = 828

local lastIcon		= nil;
local lastchase     = nil;
local phase         = 1;
local p2Start       = 0;

Supremus:RegisterCombat("COMBAT");

Supremus:RegisterEvents(
	"SPELL_AURA_APPLIED",
    "CHAT_MSG_RAID_BOSS_WHISPER"
);

Supremus:AddOption("WarnKiteTarget", true, DBM_SUPREMUS_OPTION_TARGETWARN);
Supremus:AddOption("IconKiteTarget", true, DBM_SUPREMUS_OPTION_TARGETICON);
Supremus:AddOption("WhisperKiteTarget", true, DBM_SUPREMUS_OPTION_TARGETWHISPER);

Supremus:AddBarOption("Enrage")
Supremus:AddBarOption("Kite Phase")
Supremus:AddBarOption("Tank & Spank Phase")
Supremus:AddBarOption("Chasing (.*)")

function Supremus:OnCombatStart(delay)
	self:StartStatusBarTimer(900 - delay, "Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
	self:ScheduleAnnounce(300 - delay, DBM_GENERIC_ENRAGE_WARN:format(10, DBM_MIN), 1)
	self:ScheduleAnnounce(600 - delay, DBM_GENERIC_ENRAGE_WARN:format(5, DBM_MIN), 1)
	self:ScheduleAnnounce(720 - delay, DBM_GENERIC_ENRAGE_WARN:format(3, DBM_MIN), 1)
	self:ScheduleAnnounce(840 - delay, DBM_GENERIC_ENRAGE_WARN:format(1, DBM_MIN), 2)
	self:ScheduleAnnounce(870 - delay, DBM_GENERIC_ENRAGE_WARN:format(30, DBM_SEC), 3)
	self:ScheduleAnnounce(890 - delay, DBM_GENERIC_ENRAGE_WARN:format(10, DBM_SEC), 4)
	
	self:StartStatusBarTimer(60 - delay, "Kite Phase", "Interface\\Icons\\Spell_Fire_BurningSpeed");
	self:ScheduleSelf(50 - delay, "PhaseWarn", 2);
	lastIcon = nil;
    lastchase = nil;
end

function Supremus:OnCombatEnd()
	if lastIcon then
		DBM.ClearIconByName(lastIcon);
		lastIcon = nil;
	end
    if lastchase then lastchase = nil end
end

function Supremus:OnEvent(event, arg1)
	if event == "PhaseWarn" and arg1 then
		self:Announce(getglobal("DBM_SUPREMUS_WARN_PHASE_"..tostring(arg1).."_SOON"), 1);
    elseif event == "Phase1" then
        phase = 1;
        self:StartStatusBarTimer(60, "Kite Phase", "Interface\\Icons\\Spell_Fire_BurningSpeed");
        self:ScheduleSelf(50, "PhaseWarn", 2);
        self:Announce(DBM_SUPREMUS_WARN_PHASE_1, 3);
        if lastIcon then
            DBM.ClearIconByName(lastIcon);
            lastIcon = nil;
        end
        if lastchase then
            self:EndStatusBarTimer("Chasing "..lastchase)
            lastchase = nil
        end
    elseif event == "Phase2" then
        phase = 2;
        self:StartStatusBarTimer(60, "Tank & Spank Phase", "Interface\\Icons\\Ability_Defend");
        self:ScheduleSelf(50, "PhaseWarn", 1);
        self:Announce(DBM_SUPREMUS_WARN_PHASE_2, 3);
        self:ScheduleSelf(60, "Phase1")
	elseif event == "SPELL_AURA_APPLIED" then
		if arg1.spellId == 42052 and arg1.destName == UnitName("player") then
			self:AddSpecialWarning(DBM_SUPREMUS_SPECWARN_VOLCANO);
		end
    elseif event == "CHAT_MSG_RAID_BOSS_WHISPER" then
        if string.find(arg1,DBM_SUPREMUS_EMOTE_NEWTARGET) then
            -- Supremus aquired a new target in phase 2 to chase.
            self:ScheduleMethod(0, "NewTarget")
            if phase == 1 then
                -- this code below incase our phase timers are off
                self:EndStatusBarTimer("Kite Phase")
                self:UnScheduleSelf("Phase2")
                self:ScheduleSelf(0,"Phase2")
                p2Start = GetTime();
            end
        end
	end
end

function Supremus:NewTarget()
    if phase == 1 then return end
	local target;
	for i = 1, GetNumRaidMembers() do
		if UnitName("raid"..i.."target") == DBM_SUPREMUS_NAME then
			target = UnitName("raid"..i.."targettarget");
			break
		end
	end	
	if target then
        if lastchase then
            -- GetStatusBarTimer didn't seem to work somehow, so here we go
            local timeleft = GetTime() - p2Start;
            while (timeleft > 10) do
                timeleft = timeleft - 10;
            end
            if timeleft > 0 then
                -- LYQ: this should trigger when the current target dies while getting chased, supremus will switch the target but only for the time remaining AFAIK
                self:StartStatusBarTimer(timeleft, "Chasing "..target, "Interface\\Icons\\Spell_Fire_BurningSpeed");
            else
                self:StartStatusBarTimer(10, "Chasing "..target, "Interface\\Icons\\Spell_Fire_BurningSpeed");
            end
        else
            self:StartStatusBarTimer(10, "Chasing "..target, "Interface\\Icons\\Spell_Fire_BurningSpeed");
        end
        lastchase = target;
		if self.Options.WarnKiteTarget then
			self:Announce(DBM_SUPREMUS_WARN_KITE_TARGET:format(target), 2);
		end
		if self.Options.IconKiteTarget and DBM.Rank >= 1 and self.Options.Announce then
			lastIcon = target;
			self:SetIcon(target);
		end
		if self.Options.WhisperKiteTarget and DBM.Rank >= 1 and self.Options.Announce then
			self:SendHiddenWhisper(DBM_SUPREMUS_WHISPER_RUN_AWAY, target);
		end
	end
end