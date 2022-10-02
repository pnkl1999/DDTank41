using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Managers;
using Game.Server.Packets;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Pet.Handle
{
    [PetHandleAttbute((byte)PetPackageType.EAT_PETS)]
    public class EatPet : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
            int amor = packet.ReadInt();
            int type = packet.ReadInt();
            int count = 0;
            int totalPoint = 0;
            int eatItem = 201567;
            int weaponLevel = player.PetBag.EatPets.weaponLevel;
            int weaponExp = player.PetBag.EatPets.weaponExp;
            int clothesLevel = player.PetBag.EatPets.clothesLevel;
            int clothesExp = player.PetBag.EatPets.clothesExp;
            int hatLevel = player.PetBag.EatPets.hatLevel;
            int hatExp = player.PetBag.EatPets.hatExp;

            if (amor == 0)
            {
                if (HungBuCacCho(weaponLevel, clothesLevel, hatLevel) == player.PetBag.EatPets.weaponLevel)
                {
                    player.SendMessage(eMessageType.GM_NOTICE, "Vui lòng nâng cấp Áo hoặc Nón trước!");
                    return false;
                }
            }
            if (amor == 1)
            {
                if (HungBuCacCho(weaponLevel, clothesLevel, hatLevel) == player.PetBag.EatPets.clothesLevel)
                {
                    player.SendMessage(eMessageType.GM_NOTICE, "Vui lòng nâng cấp Vũ khí và Nón trước!");
                    return false;
                }
            }
            if (amor == 2)
            {
                if (HungBuCacCho(weaponLevel, clothesLevel, hatLevel) == player.PetBag.EatPets.hatLevel)
                {
                    player.SendMessage(eMessageType.GM_NOTICE, "Vui lòng nâng cấp Vũ khí và Áo trước!");
                    return false;
                }
            }

            if (type == 1)
            {
                count = packet.ReadInt();
                for (int i = 0; i < count; i++)
                {
                    int slot = packet.ReadInt();
                    int templateID = packet.ReadInt();
                    UsersPetInfo petAt = player.PetBag.GetPetAt(slot);
                    if (petAt != null)
                    {
                        PetTemplateInfo petTemplateInfo = PetMgr.FindPetTemplate(templateID);
                        if (petTemplateInfo != null)
                        {
                            totalPoint += (int)(Math.Pow(10.0, petTemplateInfo.StarLevel - 2) + 5.0 * Math.Max(petAt.Level - 8, (double)petAt.Level * 0.2));
                        }
                    }
                    if (player.PetBag.RemovePet(petAt))
                        UpGrade(player, amor, type, totalPoint, null);
                }
            }
            else
            {
                count = packet.ReadInt();
                decimal removeNeedCount = 1;
                decimal needWeaponExp = PetMoePropertyMgr.getNeedExp(weaponExp, weaponLevel);
                decimal needClothesExp = PetMoePropertyMgr.getNeedExp(clothesExp, clothesLevel);
                decimal needHatExp = PetMoePropertyMgr.getNeedExp(hatExp, hatLevel);
                decimal needEatExp = 0;
                ItemInfo info = player.GetItemByTemplateID(eatItem);
                totalPoint += count * info.Template.Property2;
                if (info == null) 
                {
                    player.SendMessage("Không đủ số lượng đá manh hóa!");
                    return false; 
                }
                
                switch (amor)
                {
                    case 0:
                        needEatExp = needWeaponExp;
                        break;
                    case 1:
                        needEatExp = needClothesExp;
                        break;
                    case 2:
                        needEatExp = needHatExp;
                        break;
                    default:
                        player.SendMessage("Loại manh hóa không hợp lệ!.");
                        return false;
                }

                if (totalPoint > needEatExp)
                {
                    count = (int)Math.Ceiling(needEatExp / info.Template.Property2);
                    totalPoint = (int)removeNeedCount * info.Template.Property2;
                }

                if (player.RemoveTemplate(eatItem, count))
                {
                    UpGrade(player, amor, type, totalPoint, info);
                } else
                {
                    player.SendMessage("Không đủ số lượng đá manh hóa!");
                    return false;
                }
            }
            player.Out.SendEatPetsInfo(player.PetBag.EatPets);
            player.EquipBag.UpdatePlayerProperties();
            return false;
        }

        private int UpGrade(GamePlayer player, int amor, int type, int totalPoint, ItemInfo eatItem)
        {
            int Exp = 0;
            int oldLv = 0;
            int MaxLevel = PetMoePropertyMgr.FindMaxLevel();
            PetMoePropertyInfo petMoePropertyInfo = null;
            switch (amor)
            {
                case 0: //att, luc
                    {
                        Exp = player.PetBag.EatPets.weaponExp + totalPoint;
                        oldLv = player.PetBag.EatPets.weaponLevel;
                        for (int k = oldLv; k <= MaxLevel; k++)
                        {
                            petMoePropertyInfo = PetMoePropertyMgr.FindPetMoeProperty(k + 1);
                            if (petMoePropertyInfo != null && petMoePropertyInfo.Exp <= Exp)
                            {
                                player.PetBag.EatPets.weaponLevel = k + 1;
                                Exp -= petMoePropertyInfo.Exp;
                                //string msg = $"|Manh Hóa| - [{player.PlayerCharacter.NickName}] vừa manh hóa thành công Vũ khí lên cấp {player.PetBag.EatPets.weaponLevel}. Lực chiến nâng tầm cao mới!";
                                //GSPacketIn packet2 = WorldMgr.SendSysNotice(msg);
                                //GameServer.Instance.LoginServer.SendPacket(packet2);
                            }
                        }
                        if (player.PetBag.EatPets.weaponLevel == MaxLevel)
                        {
                            totalPoint = Exp > 0 ? Exp : totalPoint;
                            player.PetBag.EatPets.weaponExp = 0;
                        }
                        else
                        {
                            player.PetBag.EatPets.weaponExp = Exp;
                        }
                        break;
                    }
                case 1: //agi, hp
                    {
                        Exp = player.PetBag.EatPets.clothesExp + totalPoint;
                        oldLv = player.PetBag.EatPets.clothesLevel;
                        for (int m = oldLv; m <= MaxLevel; m++)
                        {
                            petMoePropertyInfo = PetMoePropertyMgr.FindPetMoeProperty(m + 1);
                            if (petMoePropertyInfo != null && petMoePropertyInfo.Exp <= Exp)
                            {
                                player.PetBag.EatPets.clothesLevel = m + 1;
                                Exp -= petMoePropertyInfo.Exp;
                                //string msg = $"|Manh Hóa| - [{player.PlayerCharacter.NickName}] vừa manh hóa thành công Áo lên cấp {player.PetBag.EatPets.weaponLevel}. Lực chiến nâng tầm cao mới!";
                                //GSPacketIn packet2 = WorldMgr.SendSysNotice(msg);
                                //GameServer.Instance.LoginServer.SendPacket(packet2);
                            }
                        }
                        if (player.PetBag.EatPets.clothesLevel == MaxLevel)
                        {
                            totalPoint = Exp > 0 ? Exp : totalPoint;
                            player.PetBag.EatPets.clothesExp = 0;
                        }
                        else
                        {
                            player.PetBag.EatPets.clothesExp = Exp;
                        }
                        break;
                    }
                case 2: //def, guard
                    {
                        Exp = player.PetBag.EatPets.hatExp + totalPoint;
                        oldLv = player.PetBag.EatPets.hatLevel;
                        for (int i = oldLv; i <= MaxLevel; i++)
                        {
                            petMoePropertyInfo = PetMoePropertyMgr.FindPetMoeProperty(i + 1);
                            if (petMoePropertyInfo != null && petMoePropertyInfo.Exp <= Exp)
                            {
                                player.PetBag.EatPets.hatLevel = i + 1;
                                Exp -= petMoePropertyInfo.Exp;
                                //string msg = $"|Manh Hóa| - [{player.PlayerCharacter.NickName}] vừa manh hóa thành công Nón lên cấp {player.PetBag.EatPets.weaponLevel}. Lực chiến nâng tầm cao mới!";
                                //GSPacketIn packet2 = WorldMgr.SendSysNotice(msg);
                                //GameServer.Instance.LoginServer.SendPacket(packet2);
                            }
                        }
                        if (player.PetBag.EatPets.hatLevel == MaxLevel)
                        {
                            totalPoint = Exp > 0 ? Exp : totalPoint;
                            player.PetBag.EatPets.hatExp = 0;
                        }
                        else
                        {
                            player.PetBag.EatPets.hatExp = Exp;
                        }
                        break;
                    }
            }
            if (type == 2 && eatItem != null)
            {
                return totalPoint / eatItem.Template.Property2;
            }
            return 0;
        }

        private int HungBuCacCho(int weaponLevel, int clothesLevel, int hatLevel)
        {
            int Max = weaponLevel;

            if (clothesLevel > Max)
            {
                Max = clothesLevel;
            }

            if (hatLevel > Max)
            {
                Max = hatLevel;
            }

            if (weaponLevel == clothesLevel && weaponLevel == hatLevel && clothesLevel == hatLevel)
            {
                Max = -1;
            }
            return Max;
        }
    }
}
