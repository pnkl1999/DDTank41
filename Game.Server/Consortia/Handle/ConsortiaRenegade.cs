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
    [ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_RENEGADE)]
    public class ConsortiaRenegade : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            if (Player.PlayerCharacter.ConsortiaID == 0)
                return 0;

            int id = packet.ReadInt();
            bool result = false;
            string nickName = "";
            string msg = id == Player.PlayerCharacter.ID ? "ConsortiaUserDeleteHandler.ExitFailed" : "ConsortiaUserDeleteHandler.KickFailed";
            using (ConsortiaBussiness db = new ConsortiaBussiness())
            {
                if (db.DeleteConsortiaUser(Player.PlayerCharacter.ID, id, Player.PlayerCharacter.ConsortiaID, ref msg, ref nickName))
                {
                    msg = id == Player.PlayerCharacter.ID ? "ConsortiaUserDeleteHandler.ExitSuccess" : "ConsortiaUserDeleteHandler.KickSuccess";
                    int consortiaID = Player.PlayerCharacter.ConsortiaID;
                    if (id == Player.PlayerCharacter.ID)
                    {
                        Player.ClearConsortia(isclear: true);
                        Player.Out.SendMailResponse(Player.PlayerCharacter.ID, eMailRespose.Receiver);
                    }
                    GameServer.Instance.LoginServer.SendConsortiaUserDelete(id, consortiaID, id != Player.PlayerCharacter.ID, nickName, Player.PlayerCharacter.NickName);
                    result = true;
                }
            }

            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_RENEGADE);
            pkg.WriteInt(id);
            pkg.WriteBoolean(result);
            pkg.WriteString(LanguageMgr.GetTranslation(msg));
            Player.Out.SendTCP(pkg);
            return 0;
        }
    }
}
