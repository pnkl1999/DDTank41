using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets.Client;
using Game.Base.Packets;
using Game.Server.Buffer;
using SqlDataProvider.Data;
using Bussiness;
using Game.Server.Managers;
using Bussiness.Managers;

namespace Game.Server.Consortia.Handle
{
    [ConsortiaHandleAttbute((byte)ConsortiaPackageType.BUY_BADGE)]
    public class BuyBadge : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            if (Player.PlayerCharacter.ConsortiaID == 0)
                return 0;
            bool result = false;
            int badgeID = packet.ReadInt();

            ConsortiaBadgeConfigInfo badgeInfo = ConsortiaExtraMgr.FindConsortiaBadgeConfig(badgeID);
            if (badgeInfo == null)
            {
                Player.SendMessage(LanguageMgr.GetTranslation("BuyBadge.BadgeNotFound"));
                return 0;
            }
            string msg = "BuyBadgeHandler.Fail";
            int ValidDate = 30;
            string badgeBuyTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            using (ConsortiaBussiness cb = new ConsortiaBussiness())
            {
                ConsortiaInfo _info = cb.GetConsortiaSingle(Player.PlayerCharacter.ConsortiaID);//ConsortiaMgr.FindConsortiaInfo(Player.PlayerCharacter.ConsortiaID);
                if (_info == null)
                    return 0;
                if (_info.Riches < badgeInfo.Cost)
                {
                    Player.RemoveConsortiaRiches(badgeInfo.Cost);
                    Player.SendMessage(LanguageMgr.GetTranslation("ConsortiaBussiness.Riches.Msg3"));
                    return 0;
                }
                _info.BadgeID = badgeID;
                _info.ValidDate = ValidDate;
                _info.BadgeBuyTime = badgeBuyTime;

                if (cb.BuyBadge(Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, _info, ref msg))
                {
                    msg = "BuyBadgeHandler.Success";
                    result = true;
                }

            }
            if (result)
            {
                using (PlayerBussiness db = new PlayerBussiness())
                {
                    ConsortiaUserInfo[] AllMembers = db.GetAllMemberByConsortia(Player.PlayerCharacter.ConsortiaID);

                    foreach (ConsortiaUserInfo info in AllMembers)
                    {
                        GamePlayer p = WorldMgr.GetPlayerById(info.UserID);
                        if (p != null && p.PlayerId != Player.PlayerCharacter.ID)
                        {
                            p.UpdateBadgeId(badgeID);
                            p.SendMessage(LanguageMgr.GetTranslation("Consortia.Msg7"));
                            p.UpdateProperties();
                        }
                    }
                }
            }

            Player.Out.sendBuyBadge(Player.PlayerCharacter.ConsortiaID, badgeID, ValidDate, result, badgeBuyTime, Player.PlayerCharacter.ID);
            Player.SendMessage(LanguageMgr.GetTranslation(msg));
            Player.UpdateBadgeId(badgeID);
            Player.UpdateProperties();

            if (result)
            {
                using (ConsortiaBussiness db = new ConsortiaBussiness())
                {
                    db.UpdateConsortiaRiches(Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, badgeInfo.Cost, ref msg);
                }
            }

            return 0;
        }
    }
}
