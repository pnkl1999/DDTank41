using Bussiness;
using Game.Base.Packets;
using Game.Server.Buffer;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.Rooms;

namespace Game.Server.WorldBoss.Handle
{
    [WorldBossHandle((byte)WorldBossGamePackageType.BUFF_BUY)]
    public class BuyBuff : IWorldBossCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            //var needMoney = 0;// RoomMgr.WorldBossRoom.AddInjureBuffMoney;
            //var damevalue = 0;// RoomMgr.WorldBossRoom.AddInjureValue;
            int needMoney = RoomMgr.WorldBossRoom.addInjureBuffMoney;
            int damevalue = RoomMgr.WorldBossRoom.addInjureValue;
            if (Player.MoneyDirect(needMoney, IsAntiMult: false, false))
            {
                Player.RemoveMoney(needMoney);
                AbstractBuffer buffer = BufferList.CreatePayBuffer((int)BuffType.WorldBossAttrack_MoneyBuff, damevalue, 1);
                if (buffer != null)
                {
                    buffer.Start(Player);
                }
            }

            return 0;
        }
    }
}