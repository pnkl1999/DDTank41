using System;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Bussiness;
using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.HONOR_UP_COUNT, "场景用户离开")]
    public class HonorUpHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int type = packet.ReadByte();
            bool isBland = packet.ReadBoolean();
            //Console.WriteLine("?????type: " + type + " isBland:" + isBland);
            if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
            {

                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                return 0;
            }


            switch (type)
            {
                case 1://
                    break;
                case 2://get honor by monney
                    {
                        int maxBuyHonor = client.Player.PlayerCharacter.MaxBuyHonor + 1;
                        TotemHonorTemplateInfo temp = TotemHonorMgr.FindTotemHonorTemplateInfo(maxBuyHonor);
                        if (temp == null)
                        {
                            return 0;
                        }
                        int needMoney = temp.NeedMoney;
                        int addHonnor = temp.AddHonor;
                        if (client.Player.MoneyDirect(needMoney, IsAntiMult:true, false))
                        {

                            client.Player.AddHonor(addHonnor);
                            client.Player.AddMaxHonor(1);
                            //client.Player.AddExpVip(needMoney);
                            //client.Player.RemoveMoney(needMoney);
                            //Console.WriteLine("????needMoney: " + needMoney);
                        }
                    }
                    break;
            }
            client.Player.Out.SendUpdateUpCount(client.Player.PlayerCharacter);
            return 0;
        }
    }
}
