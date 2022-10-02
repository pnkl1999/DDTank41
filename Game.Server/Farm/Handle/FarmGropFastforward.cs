using Bussiness;
using Game.Base.Packets;

namespace Game.Server.Farm.Handle
{
    [FarmHandleAttbute(18)]
	public class FarmGropFastforward : IFarmCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			bool flag = packet.ReadBoolean();
			bool isAllField = packet.ReadBoolean();
			int fieldId = packet.ReadInt();
			int num = Player.Farm.ripeNum();
			int num2 = GameProperties.FastGrowNeedMoney * num;
			if (num2 <= 0)
			{
				return false;
			}
			if (flag)
			{
				if (num2 <= Player.PlayerCharacter.GiftToken)
				{
					if (Player.RemoveGiftToken(num2) > 0)
					{
						Player.SendMessage($"Thành công! bạn đã rút ngắn 30 phút thời gian trồng của {num} cây");
						Player.Farm.GropFastforward(isAllField, fieldId);
					}
				}
			}
			else if (num2 <= Player.PlayerCharacter.Money)
			{
				if (Player.RemoveMoney(num2) > 0)
				{
					Player.SendMessage($"Thành công! bạn đã rút ngắn 30 phút thời gian trồng của {num} cây");
					Player.Farm.GropFastforward(isAllField, fieldId);
				}
			}
			return true;
        }
    }
}
