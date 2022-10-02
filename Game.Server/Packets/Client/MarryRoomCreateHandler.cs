using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.SceneMarryRooms;
using log4net;
using SqlDataProvider.Data;
using System.Reflection;

namespace Game.Server.Packets.Client
{
    [PacketHandler(241, "礼堂创建")]
    public class MarryRoomCreateHandler : IPacketHandler
    {
        protected static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            if (client.Player.PlayerCharacter.IsMarried)
            {
                if (client.Player.PlayerCharacter.IsCreatedMarryRoom)
                {
                    return 1;
                }
                if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
                {
                    client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Bag.Locked"));
                    return 0;
                }
                if (client.Player.CurrentRoom != null)
                {
                    client.Player.CurrentRoom.RemovePlayerUnsafe(client.Player);
                }
                if (client.Player.CurrentMarryRoom != null)
                {
                    client.Player.CurrentMarryRoom.RemovePlayer(client.Player);
                }
                MarryRoomInfo marryRoomInfo = new MarryRoomInfo
                {
                    Name = packet.ReadString(),
                    Pwd = packet.ReadString(),
                    MapIndex = packet.ReadInt(),
                    AvailTime = packet.ReadInt(),
                    MaxCount = packet.ReadInt(),
                    GuestInvite = packet.ReadBoolean(),
                    RoomIntroduction = packet.ReadString(),
                    ServerID = GameServer.Instance.Configuration.ServerID,
                    IsHymeneal = false
                };
                
                int num = 1000;
                switch (marryRoomInfo.AvailTime)
                {
                    case 2:
                        num = 700;
                        break;
                    case 3:
                        num = 900;
                        break;
                    case 4:
                        num = 1000;
                        break;
                    default:
                        num = 1000;
                        marryRoomInfo.AvailTime = 4;
                        break;
                }
                if (client.Player.MoneyDirect(num, IsAntiMult: false, false))
                {
                    MarryRoom marryRoom = MarryRoomMgr.CreateMarryRoom(client.Player, marryRoomInfo);
                    if (marryRoom != null)
                    {
                        GSPacketIn packet2 = client.Player.Out.SendMarryRoomInfo(client.Player, marryRoom);
                        client.Player.Out.SendMarryRoomLogin(client.Player, result: true);
                        marryRoom.SendToScenePlayer(packet2);
                        CountBussiness.InsertSystemPayCount(client.Player.PlayerCharacter.ID, num, 0, 0, 0);
                        DailyRecordInfo info = new DailyRecordInfo
                        {
                            UserID = client.Player.PlayerCharacter.ID,
                            Type = 4,
                            Value = client.Player.PlayerCharacter.SpouseName
                        };
                        new PlayerBussiness().AddDailyRecord(info);
                    }
                    return 0;
                }
            }
            return 1;
        }
    }
}
