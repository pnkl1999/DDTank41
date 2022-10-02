using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameUtils;
using Game.Server.Managers;
using Newtonsoft.Json;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.Pet.Handle
{
    [PetHandleAttbute((byte)PetPackageType.ADOPT_PET)]
    public class AdoptPet : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
            int num = packet.ReadInt();
            int num2 = player.PetBag.FindFirstEmptySlot();
            PetInventory petBag = player.PetBag;
            if (num2 == -1)
            {
                player.Out.SendRefreshPet(player, petBag.GetAdoptPet(player.PlayerCharacter.VIPLevel), null, refreshBtn: false);
                player.SendMessage(LanguageMgr.GetTranslation("Số lượng pet đã đạt giới hạn!"));
            }
            else
            {
                if (num < 0)
                {
                    player.Out.SendRefreshPet(player, petBag.GetAdoptPet(player.PlayerCharacter.VIPLevel), null, refreshBtn: false);
                    player.SendMessage(LanguageMgr.GetTranslation("Không tìm thấy pet này!"));
                    return false;
                }
                UsersPetInfo adoptPetAt = petBag.GetAdoptPetAt(num);
                adoptPetAt.VIPLevel = player.PlayerCharacter.VIPLevel;
                adoptPetAt.PetEquips = new List<PetEquipInfo>();
                using (PlayerBussiness playerBussiness = new PlayerBussiness())
                {
                    if (adoptPetAt.ID > 0)
                    {
                        playerBussiness.RemoveUserAdoptPet(adoptPetAt.ID);
                        adoptPetAt.ID = 0;
                    }
                }
                adoptPetAt.PetEquips = new List<PetEquipInfo>();
                adoptPetAt.BaseProp = JsonConvert.SerializeObject(adoptPetAt);
                if (petBag.AddPetTo(adoptPetAt, num2))
                {
                    PetTemplateInfo petTemplateInfo = PetMgr.FindPetTemplate(adoptPetAt.TemplateID);
                    if (petTemplateInfo.StarLevel > 3 || petTemplateInfo.KindID >= 5)
                    {
                        GameServer.Instance.LoginServer.SendPacket(WorldMgr.SendSysNotice($"[{player.ZoneName}] Người chơi [{player.PlayerCharacter.NickName}] may mắn bắt được {petTemplateInfo.Name} {petTemplateInfo.StarLevel} sao."));
                    }
                    else
                    {
                        player.SendMessage("Bắt thành công.");
                    }
                    player.OnAdoptPetEvent();
                }
                petBag.SaveToDatabase(saveAdopt: false);
                petBag.RemoveAdoptPet(adoptPetAt);
            }
            return false;
        }
    }
}
