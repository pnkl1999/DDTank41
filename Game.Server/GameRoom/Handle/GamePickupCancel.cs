using Bussiness;
using Game.Base.Packets;
using Game.Server.Packets;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
    [GameRoomHandleAttbute(11)]
	public class GamePickupCancel : IGameRoomCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.CurrentRoom != null)
			{
				if (Player.CurrentRoom.BattleServer != null)
				{
					Player.CurrentRoom.BattleServer.RemoveRoom(Player.CurrentRoom);
					if (Player != Player.CurrentRoom.Host)
					{
						Player.CurrentRoom.Host.Out.SendMessage(eMessageType.ChatERROR, LanguageMgr.GetTranslation("Game.Server.SceneGames.PairUp.Failed"));
						RoomMgr.UpdatePlayerState(Player, 0);
					}
					else
					{
						RoomMgr.UpdatePlayerState(Player, 2);
					}
				}
				else
				{
					Player.CurrentRoom.RemovePlayerUnsafe(Player);
				}
			}
			return true;
        }
    }
}
