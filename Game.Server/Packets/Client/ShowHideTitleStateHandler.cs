using Game.Base.Packets;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(279, "场景用户离开")]
	public class ShowHideTitleStateHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (packet.ReadBoolean())
			{
				//Console.WriteLine("Show");
			}
			else
			{
				//Console.WriteLine("Hide");
			}
			return 0;
        }
    }
}
