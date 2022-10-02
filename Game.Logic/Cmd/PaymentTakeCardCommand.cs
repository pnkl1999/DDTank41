using Bussiness;
using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(114, "付费翻牌")]
	public class PaymentTakeCardCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			if (player.HasPaymentTakeCard)
			{
				return;
			}
			bool flag;
			if (player.GetFightBuffByType(BuffType.Card_Get) != null && !game.IsSpecialPVE() && player.PlayerDetail.UsePayBuff(BuffType.Card_Get))
			{
				flag = true;
			}
			else
			{
				int num = ((player.PlayerDetail.PlayerCharacter.typeVIP > 0) ? 437 : 486);
				flag = player.PlayerDetail.RemoveMoney(num) > 0;
			}
			if (flag)
			{
				int index = packet.ReadByte();
				player.CanTakeOut++;
				player.FinishTakeCard = false;
				player.HasPaymentTakeCard = true;
				if (index >= 0 && index < game.Cards.Length)
				{
					game.TakeCard(player, index, isAuto: false);
				}
				else
				{
					game.TakeCard(player);
				}
			}
			else
			{
				player.PlayerDetail.SendInsufficientMoney(1);
			}
        }
    }
}
