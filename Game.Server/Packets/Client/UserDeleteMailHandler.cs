using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bussiness;
using SqlDataProvider.Data;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.DELETE_MAIL, "删除邮件")]
    public class UserDeleteMailHandler : IPacketHandler
    {
        public bool GetAnnex(string value)
        {
            return GetAnnex(value, null);
        }

        public bool GetAnnex(string value, GamePlayer player)
        {
            if(string.IsNullOrEmpty(value))
            {
                return false;
            }

            int itemID = int.Parse(value);
            using (PlayerBussiness playerBussiness = new PlayerBussiness())
            {
                ItemInfo userItemSingle = playerBussiness.GetUserItemSingle(itemID);
                if (userItemSingle != null && userItemSingle.UserID == 0)
                {
                    return true;
                }
            }
            return false;
        }


        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.DELETE_MAIL, client.Player.PlayerCharacter.ID);

            if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                return 0;
            }
            int id = packet.ReadInt();
            int senderID;
            pkg.WriteInt(id);
            using (PlayerBussiness db = new PlayerBussiness())
            {
                MailInfo mail = db.GetMailSingle(client.Player.PlayerCharacter.ID, id);
                if (GetAnnex(mail.Annex1) || GetAnnex(mail.Annex2) || GetAnnex(mail.Annex3) || GetAnnex(mail.Annex4) || GetAnnex(mail.Annex5))
                {
                    pkg.WriteBoolean(false);
                    client.Out.SendMailResponse(client.Player.PlayerId, eMailRespose.Receiver);
                }
                else if (db.DeleteMail(client.Player.PlayerCharacter.ID, id, out senderID))
                {
                    client.Out.SendMailResponse(senderID, eMailRespose.Receiver);
                    pkg.WriteBoolean(true);
                }
                else
                {
                    pkg.WriteBoolean(false);
                }
            }
            client.Out.SendTCP(pkg);
            return 0;
        }
    }
}
