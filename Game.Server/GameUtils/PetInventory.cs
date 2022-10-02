using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using SqlDataProvider.Data;
using Bussiness;
using Game.Server.Packets;
using Bussiness.Managers;
using Newtonsoft.Json;
using System.Reflection;
using log4net;
using Game.Logic;

namespace Game.Server.GameUtils
{
    public class PetInventory : PetAbstractInventory
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private bool m_saveToDb;
        private List<UsersPetInfo> m_removedList;
        protected GamePlayer m_player;
        public GamePlayer Player
        {
            get
            {
                return m_player;
            }
        }
        private UsersPetFormInfo m_petForm;
        public UsersPetFormInfo PetForm
        {
            get
            {
                return m_petForm;
            }
        }
        private List<PetFormActiveListInfo> m_activeList;
        public List<PetFormActiveListInfo> ActiveList
        {
            get
            {
                return m_activeList;
            }
        }
        private EatPetsInfo m_eatPets;
        public EatPetsInfo EatPets
        {
            get
            {
                return m_eatPets;
            }
        }

        public int MaxLevel
        {
            get { return Convert.ToInt32(PetMgr.FindConfig("MaxLevel").Value); }
        }

        public int MaxLevelByGrade
        {
            get
            {
                if (m_player == null)
                    return MaxLevel;

                return m_player.Level > MaxLevel ? MaxLevel : m_player.Level;
            }
        }

        public PetInventory(GamePlayer player, bool saveTodb, int capibility, int aCapability, int beginSlot)
            : base(capibility, aCapability, beginSlot)
        {
            m_player = player;
            m_saveToDb = saveTodb;
            m_removedList = new List<UsersPetInfo>();
            m_activeList = new List<PetFormActiveListInfo>();
        }


        public virtual void LoadFromDatabase()
        {
            if (m_saveToDb)
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    int id = m_player.PlayerCharacter.ID;
                    UsersPetInfo[] petLists = pb.GetUserPetSingles(id, m_player.PlayerCharacter.VIPLevel);
                    UsersPetInfo[] petAdoptLists = pb.GetUserAdoptPetSingles(id);
                    foreach (UsersPetInfo adoptPet in petAdoptLists)
                    {
                        AddAdoptPetTo(adoptPet, adoptPet.Place);
                    }
                    EatPetsInfo eatpet = pb.GetAllEatPetsByID(id);

                    BeginChanges();
                    try
                    {
                        foreach (UsersPetInfo pet in petLists)
                        {
                            #region code fix hệ thống pet của sang hệ thống pet mới

                            if (string.IsNullOrEmpty(pet.BaseProp))
                            {
                                string realId = pet.TemplateID.ToString();
                                int oldId = -1;
                                if (realId.Substring(realId.Length - 1, 1) == "1")
                                {
                                    if (pet.Level < 30)
                                    {
                                        oldId = pet.TemplateID;
                                    }
                                    else if (pet.Level < 50)
                                    {
                                        oldId = pet.TemplateID - 1;
                                    }
                                    else
                                    {
                                        oldId = pet.TemplateID - 2;
                                    }
                                }
                                else if (realId.Substring(realId.Length - 1, 1) == "2")
                                {
                                    oldId = pet.TemplateID - 1;
                                }
                                else
                                {
                                    oldId = pet.TemplateID - 2;
                                }
                                //Console.WriteLine("oldId {0}, realId {1}", oldId, realId.Substring(realId.Length - 1, 1));
                                PetTemplateInfo tempInfo = PetMgr.FindPetTemplate(oldId);
                                if (tempInfo != null)
                                {
                                    UsersPetInfo info = PetMgr.CreatePet(tempInfo, pet.UserID, pet.Place, pet.Level, Player.PlayerCharacter.VIPLevel);
                                    pet.BaseProp = JsonConvert.SerializeObject(info);
                                    UpdateEvolutionPet(info, pet.Level, MaxLevelByGrade, Player.PlayerCharacter.VIPLevel);
                                    pet.AttackGrow = info.AttackGrow;
                                    pet.DefenceGrow = info.DefenceGrow;
                                    pet.AgilityGrow = info.AgilityGrow;
                                    pet.LuckGrow = info.LuckGrow;
                                    pet.BloodGrow = info.BloodGrow;
                                    pet.DamageGrow = info.DamageGrow;
                                    pet.GuardGrow = info.GuardGrow;
                                }
                            }
                            pet.GetSkillEquip();
                            #endregion                            

                            AddPetTo(pet, pet.Place);
                        }

                        if (eatpet == null)
                        {
                            lock (m_lock)
                            {
                                m_eatPets = new EatPetsInfo { UserID = id };
                            }
                        }
                        else
                        {
                            lock (m_lock)
                            {
                                m_eatPets = eatpet;
                            }
                        }
                    }
                    finally
                    {
                        DeserializePetForms();
                        CommitChanges();
                    }
                }
            }
        }
        public virtual void SaveToDatabase(bool saveAdopt)
        {
            if (m_saveToDb)
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    lock (m_lock)
                    {
                        for (int i = 0; i < m_pets.Length; i++)
                        {
                            UsersPetInfo pet = m_pets[i];
                            if (pet != null && pet.IsDirty)
                            {
                                pet.eQPets = SerializePetEquip(pet.PetEquips);
                                if (pet.ID > 0)
                                    pb.UpdateUserPet(pet);
                                else
                                    pb.AddUserPet(pet);
                            }
                        }
                    }

                    if (saveAdopt)
                    {
                        lock (m_lock)
                        {
                            for (int i = 0; i < m_adoptPets.Length; i++)
                            {
                                UsersPetInfo pet = m_adoptPets[i];
                                if (pet != null && pet.IsDirty)
                                {
                                    if (pet.ID == 0)
                                        pb.AddUserAdoptPet(pet, false);
                                }
                            }
                        }
                    }

                    lock (m_lock)
                    {
                        if (m_eatPets != null && m_eatPets.IsDirty)
                        {
                            if (m_eatPets.ID == 0)
                            {
                                pb.AddEatPets(m_eatPets);
                            }
                            else
                            {
                                pb.UpdateEatPets(m_eatPets);
                            }
                        }
                    }

                    lock (m_lock)
                    {
                        foreach (UsersPetInfo pet in m_removedList)
                            pb.UpdateUserPet(pet);
                        m_removedList.Clear();
                    }
                }
            }
        }
        public void DeserializePetForms()
        {
            try
            {
                if (PetForm != null && !string.IsNullOrEmpty(PetForm.ActivePets))
                {
                    lock (m_lock)
                    {
                        m_activeList = JsonConvert.DeserializeObject<List<PetFormActiveListInfo>>(PetForm.ActivePets);
                    }
                }
            }
            catch (Exception e)
            {
                log.Error("DeserializeMagicHouse fail: ", e);
            }
        }

        public override bool AddPetTo(UsersPetInfo pet, int place)
        {
            if (base.AddPetTo(pet, place))
            {
                pet.UserID = m_player.PlayerCharacter.ID;
                pet.PetEquips = DeserializePetEquip(pet.eQPets);
                return true;
            }
            return false;
        }

        public List<PetEquipInfo> DeserializePetEquip(string eqString)
        {
            if (string.IsNullOrEmpty(eqString))
                return new List<PetEquipInfo>();

            List<PetEquipInfo> list = JsonConvert.DeserializeObject<List<PetEquipInfo>>(eqString);
            List<PetEquipInfo> eqs = new List<PetEquipInfo>();
            foreach (PetEquipInfo eq in list)
            {
                if (eq.Template == null)
                {
                    ItemTemplateInfo temp = ItemMgr.FindItemTemplate(eq.eqTemplateID);
                    if (temp != null)
                    {
                        PetEquipInfo info = new PetEquipInfo(temp);
                        info.eqTemplateID = eq.eqTemplateID;
                        info.eqType = eq.eqType;
                        info.ValidDate = eq.ValidDate;
                        info.startTime = eq.startTime;
                        eqs.Add(info);
                    }
                }
                else
                {
                    eqs.Add(eq);
                }

            }
            return eqs;
        }
        public string SerializePetEquip(List<PetEquipInfo> eqs)
        {
            return JsonConvert.SerializeObject(eqs);
        }
        public void UpdateEatPets()
        {
            m_player.Out.SendEatPetsInfo(EatPets);
        }
        public virtual bool OnChangedPetEquip(int place)
        {
            lock (m_lock)
            {
                if (m_pets[place] != null)
                {
                    if (m_pets[place].IsEquip)
                        m_player.EquipBag.UpdatePlayerProperties();
                }
            }

            OnPlaceChanged(place);
            return true;
        }
        public virtual void ReduceHunger()
        {
            UsersPetInfo pet = GetPetIsEquip();
            if (pet == null)
                return;
            int baseReduce = 40;
            int maxReduece = 100;
            if (pet.Hunger >= maxReduece)
            {
                if (pet.Level >= 60)
                {
                    pet.Hunger -= maxReduece;
                }
                else
                {
                    pet.Hunger -= baseReduce;
                }
                UpdatePet(pet, pet.Place);
            }
        }
        public bool CanAdd(ItemInfo item, List<PetEquipInfo> infos)
        {
            if (infos.Count == 3 || item.Template == null)
                return false;

            foreach (PetEquipInfo info in infos)
            {
                if (item.eqType() == info.eqType)
                    return false;
            }
            return true;
        }
        public bool CheckEqPetLevel(int place, ItemInfo item)
        {
            UsersPetInfo pet = GetPetAt(place);
            if (pet == null)
                return true;

            if (pet.Level < item.Template.Property2)
            {
                return true;
            }
            return false;
        }

        public bool AddEqPet(int place, ItemInfo item)
        {
            UsersPetInfo pet = GetPetAt(place);
            if (pet == null)
                return false;

            if (CanAdd(item, m_pets[place].PetEquips))
            {
                PetEquipInfo info = new PetEquipInfo(item.Template)
                {
                    eqTemplateID = item.TemplateID,
                    eqType = item.eqType(),
                    ValidDate = item.ValidDate,
                    startTime = item.BeginDate,
                };
                pet.PetEquips.Add(info);
                return true;
            }
            return false;
        }
        public PetEquipInfo GetEqPet(List<PetEquipInfo> infos, int place)
        {
            foreach (PetEquipInfo info in infos)
            {
                if (info.eqType == place)
                    return info;
            }
            return null;
        }
        public bool RemoveEqPet(int petPlace, int eqPlace)
        {
            UsersPetInfo pet = GetPetAt(petPlace);
            if (pet == null)
                return false;
            PetEquipInfo info = GetEqPet(pet.PetEquips, eqPlace);
            if (info != null)
            {
                ChangeEqPetToItem(info);
                return pet.PetEquips.Remove(info);
            }
            return false;
        }
        public void ChangeEqPetToItem(PetEquipInfo eq)
        {
            if (eq.Template == null)
                return;

            ItemInfo item = ItemInfo.CreateFromTemplate(eq.Template, 1, 105);
            item.IsBinds = true;
            item.IsUsed = true;
            item.ValidDate = eq.ValidDate;
            item.BeginDate = eq.startTime;
            //item.ItemID = eq.ItemID;
            m_player.AddTemplate(item);
        }
        public void RemoveAllEqPet(List<PetEquipInfo> infos)
        {
            foreach (PetEquipInfo info in infos)
            {
                ChangeEqPetToItem(info);
            }
        }
        public override bool RemovePet(UsersPetInfo pet)
        {
            if (base.RemovePet(pet))
            {
                if (pet.PetEquips != null && pet.PetEquips.Count > 0)
                {
                    RemoveAllEqPet(pet.PetEquips);
                }
                lock (m_removedList)
                {
                    pet.IsExit = false;
                    m_removedList.Add(pet);
                }
                return true;
            }
            return false;
        }

        public override void UpdateChangedPlaces()
        {
            int[] changedPlaces = m_changedPlaces.ToArray();
            m_player.Out.SendUpdateUserPet(this, changedPlaces);
            base.UpdateChangedPlaces();
        }

        public virtual void ClearAdoptPets()
        {
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                lock (m_lock)
                {
                    for (int i = 0; i < ACapalility; i++)
                    {
                        if (m_adoptPets[i] != null && m_adoptPets[i].ID > 0)
                            pb.ClearAdoptPet(m_adoptPets[i].ID);

                        m_adoptPets[i] = null;
                    }
                }
            }

        }
    }
}