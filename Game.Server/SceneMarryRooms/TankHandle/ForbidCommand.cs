using Game.Base.Packets;

namespace Game.Server.SceneMarryRooms.TankHandle
{
    [MarryCommandAttbute(8)]
	public class ForbidCommand : IMarryCommandHandler
    {
        public bool HandleCommand(TankMarryLogicProcessor process, GamePlayer player, GSPacketIn packet)
        {
			if (player.CurrentMarryRoom != null && (player.PlayerCharacter.ID == player.CurrentMarryRoom.Info.GroomID || player.PlayerCharacter.ID == player.CurrentMarryRoom.Info.BrideID))
			{
				int num = packet.ReadInt();
				if (num != player.CurrentMarryRoom.Info.BrideID && num != player.CurrentMarryRoom.Info.GroomID)
				{
					player.CurrentMarryRoom.KickPlayerByUserID(player, num);
					player.CurrentMarryRoom.SetUserForbid(num);
				}
				return true;
			}
			return false;
        }
    }
}
