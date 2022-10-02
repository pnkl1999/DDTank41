using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Bussiness;
namespace Game.Server.Packets.Client
{
    [PacketHandler((short)ePackageType.BAGLOCK_PWD, "二级密码")]
    public class BaglockedHandle : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int cmd = packet.ReadByte();
            GSPacketIn pkg = new GSPacketIn((short)ePackageType.BAGLOCK_PWD, client.Player.PlayerCharacter.ID);
            switch (cmd)
            {
                case (byte)BaglockedPackageType.CHECK_PHONE_BINDING:
                    {
                        pkg.WriteByte((byte)BaglockedPackageType.CHECK_PHONE_BINDING);
                        pkg.WriteBoolean(true);
                        client.Out.SendTCP(pkg);
                    }
                    break;
                default:
                    Console.WriteLine("BaglockedPackageType." + (BaglockedPackageType)cmd);
                    break;
            }

            return 0;
        }

    }


}
