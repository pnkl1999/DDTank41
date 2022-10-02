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
    [ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_DISBAND)]
    public class ConsortiaDisband : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            if (Player.PlayerCharacter.ConsortiaID == 0)
                return 0;
            if (!Player.isPassCheckCode())
            {
                Player.ShowCheckCode();
                return 1;
            }
            Player.CountFunction++;
            int id = Player.PlayerCharacter.ConsortiaID;
            string consortiaName = Player.PlayerCharacter.ConsortiaName;
            bool result = false;
            string msg = "ConsortiaDisbandHandler.Failed";
            using (ConsortiaBussiness db = new ConsortiaBussiness())
            {
                if (db.DeleteConsortia(Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, ref msg))
                {
                    result = true;
                    msg = "ConsortiaDisbandHandler.Success1";
                    Player.ClearConsortia(isclear: true);
                    GameServer.Instance.LoginServer.SendConsortiaDelete(id);
                }
            }

            string temp = LanguageMgr.GetTranslation(msg);
            if (msg == "ConsortiaDisbandHandler.Success1")
            {
                temp += consortiaName + LanguageMgr.GetTranslation("ConsortiaDisbandHandler.Success2");
            }

            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_DISBAND);
            if (result)
            {
                pkg.WriteBoolean(result);
                pkg.WriteInt(Player.PlayerCharacter.ID);
                pkg.WriteString(temp);
            }
            else
            {
                pkg.WriteInt(Player.PlayerCharacter.ID);
                pkg.WriteString(temp);
            }
            Player.Out.SendTCP(pkg);
            return 0;
        }
    }
}
