using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler((short)ePackageType.AVATAR_COLLECTION, "场景用户离开")]
    public class AvatarCollectionHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            byte b = packet.ReadByte();
            int result;
            switch (b)
            {
                case 3:
                    {
                        int num = packet.ReadInt();
                        int num2 = packet.ReadInt();
                        int num3 = packet.ReadInt();
                        if (client.Player.EquipBag.GetItemByTemplateID(0, num2) != null)
                        {
                            ClothGroupTemplateInfo clothGroup = ClothGroupTemplateInfoMgr.GetClothGroup(num, num2, num3);
                            if (clothGroup == null)
                            {
                                client.Player.SendMessage("Thời trang này không tồn tại.");
                            }
                            else
                            {
                                ClothPropertyTemplateInfo clothPropertyWithID = ClothPropertyTemplateInfoMgr.GetClothPropertyWithID(clothGroup.ID);
                                if (clothPropertyWithID == null)
                                {
                                    client.Player.SendMessage("Bộ thời trang chứa thời trang này không tồn tại.");
                                }
                                else if (client.Player.PlayerCharacter.Gold < clothGroup.Cost)
                                {
                                    client.Player.SendMessage("Vàng không đủ.");
                                }
                                else
                                {
                                    client.Player.RemoveGold(clothGroup.Cost);
                                    bool flag = false;
                                    bool flag2 = false;
                                    UserAvatarCollectionInfo userAvatarCollectionInfo = client.Player.AvatarCollect.GetAvatarCollectWithAvatarID(clothGroup.ID);
                                    if (userAvatarCollectionInfo == null)
                                    {
                                        userAvatarCollectionInfo = new UserAvatarCollectionInfo(client.Player.PlayerCharacter.ID, clothPropertyWithID.ID, clothPropertyWithID.Sex, false, DateTime.Now);
                                        client.Player.AvatarCollect.AddAvatarCollection(userAvatarCollectionInfo);
                                    }
                                    UserAvatarCollectionDataInfo item = new UserAvatarCollectionDataInfo(clothGroup.TemplateID, clothGroup.Sex);
                                    if (!userAvatarCollectionInfo.AddItem(item))
                                    {
                                        client.Player.AddGold(clothGroup.Cost);
                                        client.Player.SendMessage("Lỗi khi kích hoạt bộ thời trang.");
                                    }
                                    else
                                    {
                                        int num4 = ClothGroupTemplateInfoMgr.CountClothGroupWithID(userAvatarCollectionInfo.AvatarID);
                                        if (userAvatarCollectionInfo.Items.Count == num4 / 2 && !userAvatarCollectionInfo.IsActive)
                                        {
                                            userAvatarCollectionInfo.ActiveAvatar(10);
                                            flag = true;
                                        }
                                        if (userAvatarCollectionInfo.Items.Count == num4 / 2 || userAvatarCollectionInfo.Items.Count == num4)
                                        {
                                            flag2 = true;
                                        }
                                        if (flag)
                                        {
                                            GSPacketIn gSPacketIn = new GSPacketIn(402);
                                            gSPacketIn.WriteByte(4);
                                            gSPacketIn.WriteInt(userAvatarCollectionInfo.AvatarID);
                                            gSPacketIn.WriteInt(userAvatarCollectionInfo.Sex);
                                            gSPacketIn.WriteDateTime(userAvatarCollectionInfo.TimeEnd);
                                            client.Player.SendTCP(gSPacketIn);
                                        }
                                        GSPacketIn gSPacketIn2 = new GSPacketIn(402);
                                        gSPacketIn2.WriteByte(3);
                                        gSPacketIn2.WriteInt(num);
                                        gSPacketIn2.WriteInt(num2);
                                        gSPacketIn2.WriteInt(num3);
                                        client.Player.SendTCP(gSPacketIn2);
                                        if (flag2)
                                        {
                                            client.Player.EquipBag.UpdatePlayerProperties();
                                        }
                                        client.Player.SendMessage("Kích hoạt thành công!");
                                    }
                                }
                            }
                        }
                        else
                        {
                            client.Player.SendMessage("Bạn không sở hữu vật phẩm này.");
                        }
                        result = 1;
                        break;
                    }
                case 4:
                    {
                        int num5 = packet.ReadInt();
                        int num6 = packet.ReadInt();
                        if (num6 <= 0)
                        {
                            result = 0;
                        }
                        else if (num5 == -1)
                        {
                            int num7 = 0;
                            foreach (UserAvatarCollectionInfo current in client.Player.AvatarCollect.AvatarCollect)
                            {
                                if (!current.IsAvailable())
                                {
                                    ClothPropertyTemplateInfo clothPropertyWithID2 = ClothPropertyTemplateInfoMgr.GetClothPropertyWithID(current.AvatarID);
                                    if (clothPropertyWithID2 != null)
                                    {
                                        //int num8 = clothPropertyWithID2.Cost * num6;
                                        //if (client.Player.PlayerCharacter.myHonor < num8 || num8 <= 0)
                                        //{
                                        //	client.Player.SendMessage("Vinh dự không đủ để tiếp phí");
                                        //	break;
                                        //}
                                        //client.Player.RemovemyHonor(num8);
                                        //current.ActiveAvatar(num6);
                                        //num7++;

                                        client.Player.SendMessage("Tinh nang chua mo");
                                        break;
                                    }
                                }
                            }
                            if (num7 > 0)
                            {
                                client.Player.Out.SendAvatarCollect(client.Player.AvatarCollect);
                                client.Player.SendMessage("Tiếp phí thành công " + num7 + " bộ thời trang.");
                            }
                            result = 1;
                        }
                        else
                        {
                            UserAvatarCollectionInfo avatarCollectWithAvatarID = client.Player.AvatarCollect.GetAvatarCollectWithAvatarID(num5);
                            if (avatarCollectWithAvatarID != null)
                            {
                                if (avatarCollectWithAvatarID.Items == null)
                                {
                                    avatarCollectWithAvatarID.UpdateItems();
                                }
                                int num9 = ClothGroupTemplateInfoMgr.CountClothGroupWithID(avatarCollectWithAvatarID.AvatarID);
                                if (avatarCollectWithAvatarID.Items.Count >= num9 / 2)
                                {
                                    ClothPropertyTemplateInfo clothPropertyWithID3 = ClothPropertyTemplateInfoMgr.GetClothPropertyWithID(num5);
                                    if (clothPropertyWithID3 == null)
                                    {
                                        client.Player.SendMessage("Bộ thời trang này không thể gia hạn.");
                                    }
                                    else
                                    {
                                        //int num10 = clothPropertyWithID3.Cost * num6;
                                        //if (client.Player.PlayerCharacter.myHonor < num10 || num10 <= 0)
                                        //{
                                        //    client.Player.SendMessage("Vinh dự của bạn không đủ.");
                                        //}
                                        //else
                                        //{
                                        //    client.Player.RemovemyHonor(num10);
                                        //    avatarCollectWithAvatarID.ActiveAvatar(num6);
                                        //    GSPacketIn gSPacketIn2 = new GSPacketIn(402);
                                        //    gSPacketIn2.WriteByte(4);
                                        //    gSPacketIn2.WriteInt(avatarCollectWithAvatarID.AvatarID);
                                        //    gSPacketIn2.WriteInt(avatarCollectWithAvatarID.Sex);
                                        //    gSPacketIn2.WriteDateTime(avatarCollectWithAvatarID.TimeEnd);
                                        //    client.Player.SendTCP(gSPacketIn2);
                                        //    client.Player.SendMessage("Gia hạn thành công.");
                                        //}

                                        client.Player.SendMessage("Tinh nang chua mo");
                                    }
                                }
                                else
                                {
                                    client.Player.SendMessage("Bạn phải kích hoạt hơn 1 nửa bộ sưu tập mới có quyền gia hạn.");
                                }
                            }
                            else
                            {
                                client.Player.SendMessage("Bạn chưa kích hoạt bộ thời trang này.");
                            }
                            result = 1;
                        }
                        break;
                    }
                default:
                    Console.WriteLine("cmd_avatar_collection: " + b);
                    result = 1;
                    break;
            }
            return result;
        }
    }
}
