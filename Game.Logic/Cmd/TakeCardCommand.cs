using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(98, "翻牌")]
	public class TakeCardCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			if (!player.FinishTakeCard && player.CanTakeOut > 0)
			{
				int index = packet.ReadByte();
				if (index < 0 || index > game.Cards.Length)
				{
					game.TakeCard(player);
				}
				else
				{
					game.TakeCard(player, index, isAuto: false);
				}
			}
        }
    }
}
