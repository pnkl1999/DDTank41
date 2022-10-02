using Game.Server.Packets;
using Game.Server.GameObjects;
using Game.Base.Packets;
using Game.Logic;
using SqlDataProvider.Data;
using Bussiness;
using Game.Server.Statics;
using Bussiness.Managers;

namespace Game.Server.Pet.Handle
{
    [PetHandleAttbute((byte)FarmPackageType.BUY_PET_EXP_ITEM)]
    public class BuyPetExpItem : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
            bool isBand = packet.ReadBoolean();//true: ddtMoney false: Money
            if (player.PlayerCharacter.HasBagPassword && player.PlayerCharacter.IsLocked)
            {
                player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                return false;
            }
            UserFarmInfo farm = player.Farm.CurrentFarm;
            int timeBuy = farm.buyExpRemainNum;
            PetExpItemPriceInfo info = PetMgr.FindPetExpItemPrice(RealMoney(timeBuy));
            if (info == null || timeBuy < 1)
                return false;
            bool isContinue = false;
            int needMoney = info.Money;
            if (isBand)
            {
                if (player.MoneyDirect(needMoney, IsAntiMult: true, false))
                {
                    //player.AddExpVip(needMoney);
                    isContinue = true;
                }
            }
            else
            {
                if (needMoney <= player.PlayerCharacter.GiftToken)
                {
                    player.RemoveGiftToken(needMoney);
                    isContinue = true;
                }
                else
                {
                    if (needMoney < player.PlayerCharacter.Money)
                    {
                        player.RemoveMoney(needMoney);
                        isContinue = true;
                    }
                }
            }
            if (!isContinue)
            {
                player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg14"));
                return false;
            }
            ItemTemplateInfo item = ItemMgr.FindItemTemplate(334102);
            ItemInfo cloneItem = ItemInfo.CreateFromTemplate(item, info.ItemCount, (int)ItemAddType.Buy);
            cloneItem.IsBinds = true;
            player.AddTemplate(cloneItem, cloneItem.Template.BagType, info.ItemCount, eGameView.RouletteTypeGet);
            farm.buyExpRemainNum--;
            GSPacketIn response = new GSPacketIn((byte)ePackageType.PET);
            response.WriteByte((byte)FarmPackageType.BUY_PET_EXP_ITEM);
            response.WriteInt(farm.buyExpRemainNum);
            player.SendTCP(response);
            player.Farm.UpdateFarm(farm);

            return false;
        }
        private int RealMoney(int timebuy)
        {
            switch (timebuy)
            {
                case 19:
                    return 2;
                case 18:
                    return 3;
                case 17:
                    return 4;
                case 16:
                    return 5;
                case 15:
                    return 6;
                case 14:
                    return 7;
                case 13:
                    return 8;
                case 12:
                    return 9;
                case 11:
                    return 10;
                case 10:
                    return 11;
                case 9:
                    return 12;
                case 8:
                    return 13;
                case 7:
                    return 14;
                case 6:
                    return 15;
                case 5:
                    return 16;
                case 4:
                    return 17;
                case 3:
                    return 18;
                case 2:
                    return 19;
                case 1:
                    return 20;
            }
            return 1;
        }
    }
}
