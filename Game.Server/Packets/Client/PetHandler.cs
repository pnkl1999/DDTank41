using Bussiness;
using Game.Base.Packets;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(68, "添加好友")]
	public class PetHandler : IPacketHandler
    {
        public static Random random;

        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.PlayerCharacter.Grade < 25)
			{
				client.Player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg23"));
				return 0;
			}
			if (client.Player.PetHandler == null)
			{
				return 0;
			}
			client.Player.PetHandler.ProcessData(client.Player, packet);
			return 1;
        }

        static PetHandler()
        {
			random = new Random();
        }
    }
}
