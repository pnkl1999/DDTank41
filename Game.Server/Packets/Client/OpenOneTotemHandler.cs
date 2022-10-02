using System;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Bussiness;
using Bussiness.Managers;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.TOTEM, "场景用户离开")]
    public class OpenOneTotemHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            if (client.Player.PlayerCharacter.Grade < 20)
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("OpenOneTotemHandler.Msg1"));
                return 0;
            }
            if ((client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked))
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                return 1;
            }

            int id = client.Player.PlayerCharacter.totemId + 1;
            if (id <= 10000)
            {
                id = 10001;
            }
            if (id > TotemMgr.MaxTotem())
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("OpenOneTotemHandler.Maxlevel"));
                client.Player.Out.SendPlayerRefreshTotem(client.Player.PlayerCharacter);
                return 1;
            }

            TotemInfo info = TotemMgr.FindTotemInfo(id);
            if (info == null)
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("OpenOneTotemHandler.ErrorData"));
                client.Player.Out.SendPlayerRefreshTotem(client.Player.PlayerCharacter);
                return 1;
            }
            int needMoney = info.ConsumeExp;
            int needHonor = info.ConsumeHonor;

            if (client.Player.PlayerCharacter.myHonor >= needHonor)
            {
                if (client.Player.MoneyDirect(needMoney, IsAntiMult: true, false)) ;
                {
                    client.Player.AddTotem(id);
                    //client.Player.AddExpVip(needMoney);
                    client.Player.RemovemyHonor(needHonor);
                    client.Player.Out.SendPlayerRefreshTotem(client.Player.PlayerCharacter);
                    client.Player.EquipBag.UpdatePlayerProperties();
                    //client.Player.OnUserToemGemstoneEvent(1);
                }
            }
            else
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("OpenOneTotemHandler.Msg2"));
            }


            return 0;
        }
    }
}
