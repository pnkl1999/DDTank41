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

namespace Game.Server.Consortia.Handle
{
    [ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_INVITE)]
    public class ConsortiaInviteAdd : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            if (Player.PlayerCharacter.ConsortiaID == 0)
                return 0;

            string name = packet.ReadString();
            bool result = false;
            string msg = "ConsortiaInviteAddHandler.Failed";
            if (string.IsNullOrEmpty(name))
                return 0;
            using (ConsortiaBussiness db = new ConsortiaBussiness())
            {
                ConsortiaInviteUserInfo info = new ConsortiaInviteUserInfo();
                info.ConsortiaID = Player.PlayerCharacter.ConsortiaID;
                info.ConsortiaName = Player.PlayerCharacter.ConsortiaName;
                info.InviteDate = DateTime.Now;
                info.InviteID = Player.PlayerCharacter.ID;
                info.InviteName = Player.PlayerCharacter.NickName;
                info.IsExist = true;
                info.Remark = "";
                info.UserID = 0;
                info.UserName = name;
                if (db.AddConsortiaInviteUsers(info, ref msg))
                {
                    msg = "ConsortiaInviteAddHandler.Success";
                    result = true;
                    //Player.ConsortiaBag.ClearBag();
                    GameServer.Instance.LoginServer.SendConsortiaInvite(info.ID, info.UserID, info.UserName, info.InviteID, info.InviteName, info.ConsortiaName, info.ConsortiaID);
                }
            }

            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_INVITE);
            pkg.WriteString(name);
            pkg.WriteBoolean(result);
            pkg.WriteString(LanguageMgr.GetTranslation(msg));
            Player.Out.SendTCP(pkg);
            return 0;
        }
    }
}
