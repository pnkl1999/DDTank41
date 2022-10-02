using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(201, "礼堂数据")]
	public class HotSpringRoomEnterViewHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.CurrentHotSpringRoom != null)
			{
				GamePlayer[] allPlayers = client.Player.CurrentHotSpringRoom.GetAllPlayers();
				GamePlayer[] array = allPlayers;
				foreach (GamePlayer gamePlayer in array)
				{
					GSPacketIn gSPacketIn = new GSPacketIn(198);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.ID);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Grade);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Hide);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Repute);
					gSPacketIn.WriteString(gamePlayer.PlayerCharacter.NickName);
					gSPacketIn.WriteByte(gamePlayer.PlayerCharacter.typeVIP);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.VIPLevel);
					gSPacketIn.WriteBoolean(gamePlayer.PlayerCharacter.Sex);
					gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Style);
					gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Colors);
					gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Skin);
					gSPacketIn.WriteInt(gamePlayer.Hot_X);
					gSPacketIn.WriteInt(gamePlayer.Hot_Y);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.FightPower);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Win);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Total);
					gSPacketIn.WriteInt(gamePlayer.Hot_Direction);
					client.Player.SendTCP(gSPacketIn);
				}
			}
			return 0;
        }
    }
}
