using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(40, "使用飞行技能")]
	public class FlyCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			if (player.IsAttacking)
			{
				player.UseFlySkill();
			}
        }
    }
}
