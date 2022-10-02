using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Packets;

namespace Game.Server.SceneMarryRooms.TankHandle
{
    [MarryCommandAttbute(11)]
	public class GunsaluteCommand : IMarryCommandHandler
    {
        public bool HandleCommand(TankMarryLogicProcessor process, GamePlayer player, GSPacketIn packet)
        {
			if (player.CurrentMarryRoom != null)
			{
				packet.ReadInt();
				if (ItemMgr.FindItemTemplate(packet.ReadInt()) != null && !player.CurrentMarryRoom.Info.IsGunsaluteUsed && (player.CurrentMarryRoom.Info.GroomID == player.PlayerCharacter.ID || player.CurrentMarryRoom.Info.BrideID == player.PlayerCharacter.ID))
				{
					player.CurrentMarryRoom.ReturnPacketForScene(player, packet);
					player.CurrentMarryRoom.Info.IsGunsaluteUsed = true;
					GSPacketIn packet2 = player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("GunsaluteCommand.Successed1", player.PlayerCharacter.NickName));
					player.CurrentMarryRoom.SendToPlayerExceptSelfForScene(packet2, player);
					GameServer.Instance.LoginServer.SendMarryRoomInfoToPlayer(player.CurrentMarryRoom.Info.GroomID, state: true, player.CurrentMarryRoom.Info);
					GameServer.Instance.LoginServer.SendMarryRoomInfoToPlayer(player.CurrentMarryRoom.Info.BrideID, state: true, player.CurrentMarryRoom.Info);
					using (PlayerBussiness playerBussiness = new PlayerBussiness())
					{
						playerBussiness.UpdateMarryRoomInfo(player.CurrentMarryRoom.Info);
					}
					return true;
				}
			}
			return false;
        }
    }
}
