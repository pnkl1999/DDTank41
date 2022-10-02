using System.Collections;

namespace Game.Server.Achievement
{
    public class BaseUserRecord
    {
        protected GamePlayer m_player;

        protected int m_type;

        public BaseUserRecord(GamePlayer player, int type)
        {
            m_player = player;
            m_type = type;
        }

        public virtual void AddTrigger(GamePlayer player)
        {
        }

        public virtual void RemoveTrigger(GamePlayer player)
        {
        }

        public static void CreateCondition(Hashtable ht, GamePlayer m_player)
        {
            foreach (DictionaryEntry item in ht)
            {
                int num = int.Parse(item.Key.ToString());
                switch (num)
                {
                    case 1:
                        new ChangeAttackCondition(m_player, num);
                        break;
                    case 2:
                        new ChangeDefenceCondition(m_player, num);
                        break;
                    case 3:
                        new ChangeAgilityCondition(m_player, num);
                        break;
                    case 4:
                        new ChangeLuckyCondition(m_player, num);
                        break;
                    case 5:
                        new Mission4KillCondition(m_player, num);
                        break;
                    case 6:
                        new Mission9OverCondition(m_player, num);
                        break;
                    case 7:
                        new MissionKillChiefCondition(m_player, num);
                        break;
                    case 8:
                        new MissionKillMinotaurCondition(m_player, num);
                        break;
                    case 9:
                        new ChangeFightPowerCondition(m_player, num);
                        break;
                    case 10:
                        new ChangeGradeCondition(m_player, num);
                        break;
                    case 11:
                        new ChangeTotalCondition(m_player, num);
                        break;
                    case 12:
                        new ChangeWinCondition(m_player, num);
                        break;
                    case 13:
                        new ChangeOnlineTimeCondition(m_player, num);
                        break;
                    case 14:
                        new FightByFreeCondition(m_player, num);
                        break;
                    case 15:
                        new FightByGuildCondition(m_player, num);
                        break;
                    case 17:
                        new FightByGuildSpanAreaCondition(m_player, num);
                        break;
                    case 18:
                        new MarryApplyReplyCondition(m_player, num);
                        break;
                    case 19:
                        new GameKillByGameCondition(m_player, num);
                        break;
                    case 20:
                        new FightDispatchesCondition(m_player, num);
                        break;
                    case 21:
                        new QuestBlueCondition(m_player, num);
                        break;
                    case 22:
                        new QuestDailyCondition(m_player, num);
                        break;
                    case 23:
                        new PlayerGoodsPresentCondition(m_player, num);
                        break;
                    case 24:
                        new AddRichesOfferCondition(m_player, num);
                        break;
                    case 25:
                        new AddRichesRobCondition(m_player, num);
                        break;
                    case 26:
                        new Mission1KillCondition(m_player, num);
                        break;
                    case 27:
                        new Mission2KillCondition(m_player, num);
                        break;
                    case 28:
                        new Mission1OverCondition(m_player, num);
                        break;
                    case 29:
                        new Mission2OverCondition(m_player, num);
                        break;
                    case 30:
                        new Mission8OverCondition(m_player, num);
                        break;
                    case 31:
                        new Mission3KillCondition(m_player, num);
                        break;
                    case 32:
                        new ItemStrengthenCondition(m_player, num);
                        break;
                    case 33:
                        new HotSpringCondition(m_player, num);
                        break;
                    case 34:
                        new UsingIgnoreArmorCondition(m_player, num);
                        break;
                    case 35:
                        new UsingAtomicBombCondition(m_player, num);
                        break;
                    case 36:
                        new ChangeColorsCondition(m_player, num);
                        break;
                    case 37:
                        new PlayerLoginCondition(m_player, num);
                        break;
                    case 38:
                        new AddGoldCondition(m_player, num);
                        break;
                    case 39:
                        new AddGiftTokenCondition(m_player, num);
                        break;
                    case 40:
                        new AddMedalCondition(m_player, num);
                        break;
                    case 41:
                        new FightOneBloodIsWinCondition(m_player, num);
                        break;
                    case 42:
                        new UsingSecondWeaponTrueAngelCondition(m_player, num);
                        break;
                    case 43:
                        new UsingGEMCondition(m_player, num);
                        break;
                    case 44:
                        new UsingRenameCardCondition(m_player, num);
                        break;
                    case 45:
                        new UsingSalutingGunCondition(m_player, num);
                        break;
                    case 46:
                        new UsingSpanAreaBugleCondition(m_player, num);
                        break;
                    case 47:
                        new UsingBigBugleCondition(m_player, num);
                        break;
                    case 48:
                        new UsingSmallBugleCondition(m_player, num);
                        break;
                    case 49:
                        new UsingEngagementRingCondition(m_player, num);
                        break;
                    case 50:
                        new FightAddOfferCondition(m_player, num);
                        break;
                    case 51:
                        new FightCoupleCondition(m_player, num);
                        break;
                    case 52:
                        new Mission3OverCondition(m_player, num);
                        break;
                    case 53:
                        new Mission4OverCondition(m_player, num);
                        break;
                    case 54:
                        new Mission5OverCondition(m_player, num);
                        break;
                    case 55:
                        new Mission6OverCondition(m_player, num);
                        break;
                    case 56:
                        new Mission7OverCondition(m_player, num);
                        break;
                    case 57:
                        new ItemStrengthenCondition(m_player, num);
                        break;
                    case 58:
                        new UsingSuperWeaponCondition(m_player, num);
                        break;
                    case 59:
                        new QuestGoodManCardCondition(m_player, num);
                        break;
                    case 60:
                        new MissionKillTerrorKingCondition(m_player, num);
                        break;
                    case 61:
                        new MissionKillTerrorBoguCondition(m_player, num);
                        break;
                    case 64:
                        new FightWithWeaponCondition(m_player, num);
                        break;
                    case 65:
                        new FightWithWeaponCondition(m_player, num);
                        break;
                    case 66:
                        new FightWithWeaponCondition(m_player, num);
                        break;
                    case 67:
                        new FightWithWeaponCondition(m_player, num);
                        break;
                    case 68:
                        new FightWithWeaponCondition(m_player, num);
                        break;
                    case 69:
                        new FightWithWeaponCondition(m_player, num);
                        break;
                    case 70:
                        new FightWithWeaponCondition(m_player, num);
                        break;
                    case 71:
                        new FightWithWeaponCondition(m_player, num);
                        break;
                    case 72:
                        new FightWithWeaponCondition(m_player, num);
                        break;
                    case 73:
                        new FightByFreeSpanAreaCondition(m_player, num);
                        break;
                    case 74:
                        new VIPCondition(m_player, num);
                        break;
                    case 75:
                        new GetApprenticeCondition(m_player, num);
                        break;
                    case 76:
                        new ApprenticeCompleteCondition(m_player, num);
                        break;
                    case 77:
                        new GetMasterCondition(m_player, num);
                        break;
                    case 78:
                        new MasterCompleteCondition(m_player, num);
                        break;
                    case 79:
                        new Mission5KillCondition(m_player, num);
                        break;
                    case 80:
                        new Mission10OverCondition(m_player, num);
                        break;
                    case 81:
                        new MissionKillMekaCondition(m_player, num);
                        break;
                    case 82:
                        new Mission11OverCondition(m_player, num);
                        break;
                    case 83:
                        new MissionEquipCardMYZCCondition(m_player, num);
                        break;
                    case 84:
                        new MissionEquipCardBGWCCondition(m_player, num);
                        break;
                    case 85:
                        new MissionEquipCardXSBLCondition(m_player, num);
                        break;
                    case 86:
                        new MissionEquipCardHABLCondition(m_player, num);
                        break;
                    case 87:
                        new MissionEquipCardSSQCondition(m_player, num);
                        break;
                    case 88:
                        new StartMissionCondition(m_player, num);
                        break;
                    case 89:
                        new MissionKillBatosCondition(m_player, num);
                        break;
                    case 90:
                        new Mission12OverCondition(m_player, num);
                        break;
                    case 91:
                        new MissionEquipCardGBLCondition(m_player, num);
                        break;
                    case 92:
                        new MissionEquipCardXJCondition(m_player, num);
                        break;
                    case 93:
                        new MissionEquipCardBGYDHCondition(m_player, num);
                        break;
                    case 94:
                        new FightLabPrimaryCondition(m_player, num);
                        break;
                    case 95:
                        new MissionEquipCardWSBCondition(m_player, num);
                        break;
                }
            }
        }
    }
}
