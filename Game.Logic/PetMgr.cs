using System;
using System.Collections.Generic;
using log4net;
using System.Reflection;
using System.Threading;
using Bussiness;
using System.Linq;
using SqlDataProvider.Data;

namespace Game.Logic
{
    public class PetMgr
    {
        /// <summary>
        /// Defines a logger for this class.
        /// </summary>
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private static Dictionary<string, PetConfig> m_configs;
        private static Dictionary<int, PetLevel> m_levels;
        private static Dictionary<int, PetSkillElementInfo> m_skillElements;
        private static Dictionary<int, PetSkillInfo> m_skills;
        private static Dictionary<int, PetSkillTemplateInfo> m_skillTemplates;
        private static Dictionary<int, PetTemplateInfo> m_templateIds;
        private static Dictionary<int, PetExpItemPriceInfo> m_expItemPrices;
        private static Dictionary<int, PetFightPropertyInfo> m_fightProperty;
        private static Dictionary<int, PetStarExpInfo> m_starExp;
        private static List<GameNeedPetSkillInfo> m_gameNeedPetSkillInfos = new List<GameNeedPetSkillInfo>();
        private static Random rand;

        public static bool Init()
        {
            try
            {
                rand = new Random();
                return ReLoad();

            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("PetInfoMgr", e);
                return false;
            }

        }
        public static bool ReLoad()
        {
            try
            {
                Dictionary<string, PetConfig> tempConfigs = new Dictionary<string, PetConfig>();
                Dictionary<int, PetLevel> tempLevels = new Dictionary<int, PetLevel>();
                Dictionary<int, PetSkillElementInfo> tempSkillElements = new Dictionary<int, PetSkillElementInfo>();
                Dictionary<int, PetSkillInfo> tempSkills = new Dictionary<int, PetSkillInfo>();
                Dictionary<int, PetSkillTemplateInfo> tempSkillTemplates = new Dictionary<int, PetSkillTemplateInfo>();
                Dictionary<int, PetTemplateInfo> tempPetTemplates = new Dictionary<int, PetTemplateInfo>();
                Dictionary<int, PetTemplateInfo> tempTemplateIds = new Dictionary<int, PetTemplateInfo>();
                Dictionary<int, PetExpItemPriceInfo> tempExpItemPrices = new Dictionary<int, PetExpItemPriceInfo>();
                Dictionary<int, PetFightPropertyInfo> tempFightProperty = new Dictionary<int, PetFightPropertyInfo>();
                Dictionary<int, PetStarExpInfo> tempStarExp = new Dictionary<int, PetStarExpInfo>();
                if (LoadPetFromDb(tempConfigs, tempLevels, tempSkillElements, tempSkills, tempSkillTemplates, tempTemplateIds, tempExpItemPrices, tempFightProperty, tempStarExp))
                {
                    try
                    {
                        m_configs = tempConfigs;
                        m_levels = tempLevels;
                        m_skillElements = tempSkillElements;
                        m_skills = tempSkills;
                        m_skillTemplates = tempSkillTemplates;
                        m_templateIds = tempTemplateIds;
                        m_expItemPrices = tempExpItemPrices;
                        m_fightProperty = tempFightProperty;
                        m_starExp = tempStarExp;
                        List<GameNeedPetSkillInfo> tempGameNeedPetSkills = LoadGameNeedPetSkill();
                        if (tempGameNeedPetSkills.Count > 0)
                        {
                            Interlocked.Exchange(ref m_gameNeedPetSkillInfos, tempGameNeedPetSkills);
                        }
                        return true;
                    }
                    catch
                    { }

                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("PetMgr", e);
            }

            return false;
        }
        public static PetStarExpInfo[] GetPetStarExp()
        {
            return m_starExp.Values.ToArray();
        }
        public static PetStarExpInfo FindPetStarExp(int oldID)
        {
            m_clientLocker.AcquireWriterLock(Timeout.Infinite);
            try
            {
                if (m_starExp.ContainsKey(oldID))
                {
                    PetStarExpInfo item = m_starExp[oldID];
                    return item;
                }
            }
            finally
            {
                m_clientLocker.ReleaseWriterLock();
            }
            return null;
        }
        public static GameNeedPetSkillInfo[] GetGameNeedPetSkill()
        {
            return m_gameNeedPetSkillInfos.ToArray();
        }
        public static List<GameNeedPetSkillInfo> LoadGameNeedPetSkill()
        {
            List<GameNeedPetSkillInfo> list = new List<GameNeedPetSkillInfo>();
            List<string> effectPics = new List<string>();
            foreach (PetSkillInfo info in m_skills.Values)
            {
                string effect = info.EffectPic;
                if (!string.IsNullOrEmpty(effect) && !effectPics.Contains(effect))
                {
                    GameNeedPetSkillInfo needSkill = new GameNeedPetSkillInfo();
                    needSkill.Pic = info.Pic;
                    needSkill.EffectPic = info.EffectPic;
                    list.Add(needSkill);
                    effectPics.Add(effect);
                }
            }
            foreach (PetSkillElementInfo info in m_skillElements.Values)
            {
                string effect = info.EffectPic;
                if (!string.IsNullOrEmpty(effect) && !effectPics.Contains(effect))
                {
                    GameNeedPetSkillInfo needSkill = new GameNeedPetSkillInfo();
                    needSkill.Pic = info.Pic;
                    needSkill.EffectPic = info.EffectPic;
                    list.Add(needSkill);
                    effectPics.Add(effect);
                }
            }
            return list;
        }
        private static bool LoadPetFromDb(Dictionary<string, PetConfig> Config, Dictionary<int, PetLevel> Level, Dictionary<int, PetSkillElementInfo> SkillElement, Dictionary<int, PetSkillInfo> Skill,
             Dictionary<int, PetSkillTemplateInfo> SkillTemplate, Dictionary<int, PetTemplateInfo> TemplateId, Dictionary<int, PetExpItemPriceInfo> PetExpItemPrice,
             Dictionary<int, PetFightPropertyInfo> FightProperty, Dictionary<int, PetStarExpInfo> StarExp)
        {
            using (ProduceBussiness db = new ProduceBussiness())
            {
                PetConfig[] ConfigInfos = db.GetAllPetConfig();
                PetLevel[] LevelInfos = db.GetAllPetLevel();
                PetSkillElementInfo[] SkillElementInfos = db.GetAllPetSkillElementInfo();
                PetSkillInfo[] SkillInfos = db.GetAllPetSkillInfo();
                PetSkillTemplateInfo[] SkillTemplateInfos = db.GetAllPetSkillTemplateInfo();
                PetTemplateInfo[] PetTemplateInfos = db.GetAllPetTemplateInfo();
                PetExpItemPriceInfo[] PetTempExpItemPrices = db.GetAllPetExpItemPrice();
                PetFightPropertyInfo[] FightPropertys = db.GetAllPetFightProperty();
                PetStarExpInfo[] StarExps = db.GetAllPetStarExp();
                foreach (PetExpItemPriceInfo info in PetTempExpItemPrices)
                {
                    if (!PetExpItemPrice.ContainsKey(info.Count)) { PetExpItemPrice.Add(info.Count, info); }
                }

                foreach (PetConfig info in ConfigInfos)
                {
                    if (!Config.ContainsKey(info.Name)) { Config.Add(info.Name, info); }
                }
                foreach (PetLevel info in LevelInfos)
                {
                    if (!Level.ContainsKey(info.Level)) { Level.Add(info.Level, info); }
                }
                foreach (PetSkillElementInfo info in SkillElementInfos)
                {
                    if (!SkillElement.ContainsKey(info.ID)) { SkillElement.Add(info.ID, info); }
                }

                foreach (PetSkillTemplateInfo info in SkillTemplateInfos)
                {
                    if (!SkillTemplate.ContainsKey(info.SkillID)) { SkillTemplate.Add(info.SkillID, info); }
                }

                foreach (PetTemplateInfo info in PetTemplateInfos)
                {
                    if (!TemplateId.ContainsKey(info.TemplateID)) { TemplateId.Add(info.TemplateID, info); }
                }
                foreach (PetSkillInfo info in SkillInfos)
                {
                    if (!Skill.ContainsKey(info.ID)) { Skill.Add(info.ID, info); }
                }
                foreach (PetFightPropertyInfo info in FightPropertys)
                {
                    if (!FightProperty.ContainsKey(info.ID)) { FightProperty.Add(info.ID, info); }
                }
                foreach (PetStarExpInfo info in StarExps)
                {
                    if (!StarExp.ContainsKey(info.OldID)) { StarExp.Add(info.OldID, info); }
                }
                //Console.WriteLine("StarExp {0}", StarExp.Count);
            }

            return true;
        }

        private static ReaderWriterLock m_clientLocker = new ReaderWriterLock();
        public static PetFightPropertyInfo FindFightProperty(int level)
        {
            m_clientLocker.AcquireWriterLock(Timeout.Infinite);
            try
            {
                if (m_fightProperty.ContainsKey(level))
                    return m_fightProperty[level];
            }
            finally
            {
                m_clientLocker.ReleaseWriterLock();
            }
            return null;
        }
        public static int GetEvolutionGP(int level)
        {
            PetFightPropertyInfo info = FindFightProperty(level + 1);
            if (info != null)
                return info.Exp;
            return -1;
        }
        public static int GetEvolutionMax()
        {
            return m_fightProperty.Count;
        }
        public static int GetEvolutionGrade(int GP)
        {
            int MaxLevel = m_fightProperty.Count;
            if (GP >= FindFightProperty(MaxLevel).Exp)
                return MaxLevel;

            for (int i = 1; i <= MaxLevel; i++)
            {
                PetFightPropertyInfo info = FindFightProperty(i);
                if (info == null)
                    return 1;
                if (GP < info.Exp)
                    return (i - 1) < 0 ? 0 : (i - 1);
            }
            return 0;
        }
        public static PetExpItemPriceInfo FindPetExpItemPrice(int count)
        {
            if (m_expItemPrices == null)
                Init();

            if (m_expItemPrices.ContainsKey(count))
                return m_expItemPrices[count];

            return null;
        }
        public static PetConfig FindConfig(string key)
        {
            if (m_configs == null)
                Init();

            if (m_configs.ContainsKey(key))
                return m_configs[key];

            return null;
        }
        public static PetLevel FindPetLevel(int level)
        {
            if (m_levels == null)
                Init();

            if (m_levels.ContainsKey(level))
                return m_levels[level];

            return null;
        }
        public static PetSkillElementInfo FindPetSkillElement(int SkillID)
        {
            if (m_skillElements == null)
                Init();

            if (m_skillElements.ContainsKey(SkillID))
                return m_skillElements[SkillID];

            return null;
        }
        public static PetSkillInfo FindPetSkill(int SkillID)
        {
            if (m_skills == null)
                Init();

            if (m_skills.ContainsKey(SkillID))
                return m_skills[SkillID];

            return null;
        }
        public static PetSkillInfo[] GetPetSkills()
        {
            List<PetSkillInfo> infos = new List<PetSkillInfo>();
            if (m_skills == null)
                Init();

            foreach (PetSkillInfo info in m_skills.Values)
            {
                infos.Add(info);
            }
            return infos.ToArray();
        }
        public static PetSkillTemplateInfo GetPetSkillTemplate(int ID)
        {
            if (m_skillTemplates == null)
                Init();

            if (m_skillTemplates.ContainsKey(ID))
                return m_skillTemplates[ID];

            return null;
        }
        public static PetTemplateInfo FindPetTemplate(int TemplateID)
        {
            m_clientLocker.AcquireWriterLock(Timeout.Infinite);
            try
            {
                if (m_templateIds.ContainsKey(TemplateID))
                    return m_templateIds[TemplateID];
            }
            finally
            {
                m_clientLocker.ReleaseWriterLock();
            }
            return null;
        }
        public static PetTemplateInfo FindPetTemplateByKind(int star, int kindId)
        {
            foreach (PetTemplateInfo info in m_templateIds.Values)
            {
                if (info.KindID == kindId && star == info.StarLevel)
                    return info;
            }
            return null;
        }
        public static List<int> GetPetSkillByKindID(int KindID, int lv, int playerLevel)
        {
            int MaxLevel = playerLevel;// Convert.ToInt32(FindConfig("MaxLevel").Value);
            List<int> infos = new List<int>();
            List<string> DeleteSkillIDs = new List<string>();
            PetSkillTemplateInfo[] skillInfos = GetPetSkillByKindID(KindID);
            int _level = lv > MaxLevel ? MaxLevel : lv;
            for (int index = 1; index <= _level; index++)
            {
                foreach (PetSkillTemplateInfo s in skillInfos)
                {
                    if (s.MinLevel == index)
                    {
                        string[] delS = s.DeleteSkillIDs.Split(',');
                        foreach (string i in delS)
                        {
                            DeleteSkillIDs.Add(i);
                        }
                        infos.Add(s.SkillID);
                    }

                }
            }
            foreach (string i in DeleteSkillIDs)
            {
                if (!string.IsNullOrEmpty(i))//i != null && i != "")
                {
                    //Console.WriteLine("id: " + i);
                    int del = int.Parse(i);
                    infos.Remove(del);
                }
            }
            infos.Sort();

            return infos;
        }
        public static PetSkillTemplateInfo[] GetPetSkillByKindID(int KindID)
        {
            List<PetSkillTemplateInfo> infos = new List<PetSkillTemplateInfo>();
            switch (KindID)
            {
                case 12:
                    foreach (PetSkillTemplateInfo skill in m_skillTemplates.Values)
                    {
                        if ((skill.KindID == 11 && skill.SkillID < 363) || skill.KindID == 12)
                        {
                            infos.Add(skill);
                        }
                    }
                    break;
                default:
                    foreach (PetSkillTemplateInfo skill in m_skillTemplates.Values)
                    {
                        if (skill.KindID == KindID)
                        {
                            infos.Add(skill);
                        }
                    }
                    break;
            }
            return infos.ToArray();
        }

        public static List<UsersPetInfo> CreateAdoptList(int userID, int playerLevel, int vipLv)
        {
            int AdoptCount = Convert.ToInt32(FindConfig("AdoptCount").Value);
            List<UsersPetInfo> infos = new List<UsersPetInfo>();
            List<PetTemplateInfo> petIdInfos = null;
            for (int index = 0; index < AdoptCount;)
            {
                if (DropInventory.GetPetDrop(613, 1, ref petIdInfos))
                {
                    if (petIdInfos != null)
                    {
                        int id = rand.Next(petIdInfos.Count);
                        UsersPetInfo info = CreatePet(petIdInfos[id], userID, index, playerLevel, vipLv);
                        info.IsExit = true;
                        infos.Add(info);
                        index++;
                    }
                }
            }
            return infos;
        }

        public static List<UsersPetInfo> CreateFirstAdoptList(int userID, int playerLevel, int vipLv)
        {
            List<int> idpet = new List<int> { 100301, 110301, 120301, 130301 };
            List<UsersPetInfo> infos = new List<UsersPetInfo>();
            for (int index = 0; index < idpet.Count; index++)
            {
                PetTemplateInfo tempInfo = FindPetTemplate(idpet[index]);
                UsersPetInfo info = CreatePet(tempInfo, userID, index, playerLevel, vipLv);
                info.IsExit = true;
                infos.Add(info);
            }
            return infos;
        }
        //---------------------------------------

        public static string ActiveEquipSkill(int Level, int vipLevel)
        {

            string[] activeSlot = new string[] { "0,0", "-1,1", "-1,2", "-1,3", "-1,4" };

            if (Level >= 20 && Level < 30) { activeSlot[1] = "0,1"; }
            if (Level >= 30 && Level < 50)
            {
                activeSlot[1] = "0,1";
                activeSlot[2] = "0,2";
            }
            if (Level >= 50)
            {
                activeSlot[1] = "0,1";
                activeSlot[2] = "0,2";
                activeSlot[3] = "0,3";
            }
            if (vipLevel >= 7) { activeSlot[4] = "0,4"; }

            string skillPet = activeSlot[0];
            for (int i = 1; i < activeSlot.Length; i++)
            {
                skillPet += "|" + activeSlot[i];
            }
            return skillPet;
        }
        public static int UpdateEvolution(int TemplateID, int lv, ref int evoluTime)
        {
            string realId = TemplateID.ToString();
            int EvolutionLevel1 = Convert.ToInt32(FindConfig("EvolutionLevel1").Value);
            int EvolutionLevel2 = Convert.ToInt32(FindConfig("EvolutionLevel2").Value);
            evoluTime = 1;
            int nextId = -1;

            if (realId.Substring(realId.Length - 1, 1) == "1")
            {
                if (lv < EvolutionLevel1)
                {
                    nextId = TemplateID;
                }
                else if (lv < EvolutionLevel2)
                {
                    nextId = TemplateID + 1;
                }
                else
                {
                    nextId = TemplateID + 2;
                    evoluTime = 2;
                }
            }
            else if (realId.Substring(realId.Length - 1, 1) == "2")
            {
                nextId = TemplateID + 1;
            }
            else
            {
                nextId = TemplateID;
            }
            PetTemplateInfo nextinfo = FindPetTemplate(nextId);
            if (nextinfo != null)
            {
                return nextinfo.TemplateID;
            }
            return TemplateID;
        }

        public static string UpdateSkillPet(int Level, int TemplateID, int playerLevel)
        {
            string skillPet = "";
            PetTemplateInfo info = FindPetTemplate(TemplateID);
            if (info == null)
            {
                log.Error("Pet not found: " + TemplateID);
                return skillPet;
            }
            List<int> listSkillId = GetPetSkillByKindID(info.KindID, Level, playerLevel);

            if (listSkillId.Count > 0)
            {
                skillPet = listSkillId[0] + ",0";
                for (int i = 1; i < listSkillId.Count; i++)
                {
                    skillPet += "|" + listSkillId[i] + "," + i;
                }
            }
            else
            {
                log.Error("Pet skill not found! info.KindID: " + info.KindID);
            }
            return skillPet;
        }

        public static int GetLevel(int GP, int playerLevel)
        {
            int MaxLevel = playerLevel;// Convert.ToInt32(PetMgr.FindConfig("MaxLevel").Value);
            if (GP >= FindPetLevel(MaxLevel).GP)
                return MaxLevel;

            for (int i = 1; i <= MaxLevel; i++)
            {
                if (GP < FindPetLevel(i).GP)
                    return (i - 1) == 0 ? 1 : (i - 1);
            }
            return 1;
        }

        public static int GetGP(int level, int playerLevel)
        {
            int MaxLevel = playerLevel;// Convert.ToInt32(PetMgr.FindConfig("MaxLevel").Value);
            for (int i = 1; i <= MaxLevel; i++)
            {
                if (level == FindPetLevel(i).Level)
                {
                    return FindPetLevel(i).GP;
                }
            }

            return 0;
        }

        public static void GetEvolutionPropArr(UsersPetInfo _petInfo, PetTemplateInfo petTempleteInfo, ref double[] propArr, ref double[] growArr)
        {
            double[] _currentPropArr = new double[] { _petInfo.Blood * 100, _petInfo.Attack * 100, _petInfo.Defence * 100, _petInfo.Agility * 100, _petInfo.Luck * 100 };
            double[] _currentGrowArr = new double[] { _petInfo.BloodGrow, _petInfo.AttackGrow, _petInfo.DefenceGrow, _petInfo.AgilityGrow, _petInfo.LuckGrow };

            double[] _oldPropArr = new double[] { petTempleteInfo.HighBlood, petTempleteInfo.HighAttack, petTempleteInfo.HighDefence, petTempleteInfo.HighAgility, petTempleteInfo.HighLuck };
            double[] _oldGrowArr = new double[] { petTempleteInfo.HighBloodGrow, petTempleteInfo.HighAttackGrow, petTempleteInfo.HighDefenceGrow, petTempleteInfo.HighAgilityGrow, petTempleteInfo.HighLuckGrow };

            double[] _propLevelArr_one = _oldPropArr;
            double[] _growLevelArr_one = GetAddedPropArr(1, _oldGrowArr);

            double[] _propLevelArr_two = _oldPropArr;
            double[] _growLevelArr_two = GetAddedPropArr(2, _oldGrowArr);

            double[] _propLevelArr_three = _oldPropArr;
            double[] _growLevelArr_three = GetAddedPropArr(3, _oldGrowArr);

            if (_petInfo.Level < 30)
            {
                for (int p1 = 0; p1 < _propLevelArr_one.Length; p1++)
                {
                    _propLevelArr_one[p1] = _propLevelArr_one[p1] + ((_petInfo.Level - 1) * _growLevelArr_one[p1] - _currentPropArr[p1]);
                    _growLevelArr_one[p1] = _growLevelArr_one[p1] - _currentGrowArr[p1];

                    _propLevelArr_one[p1] = Math.Ceiling(_propLevelArr_one[p1] / 10) / 10;
                    _growLevelArr_one[p1] = Math.Ceiling(_growLevelArr_one[p1] / 10) / 10;
                }
                propArr = _propLevelArr_one;
                growArr = _growLevelArr_one;
            }
            else if (_petInfo.Level < 50)
            {
                for (int p2 = 0; p2 < _propLevelArr_two.Length; p2++)
                {
                    _propLevelArr_two[p2] = _propLevelArr_two[p2] + ((_petInfo.Level - 30) * _growLevelArr_two[p2] + 29 * _growLevelArr_one[p2] - _currentPropArr[p2]);
                    _growLevelArr_two[p2] = _growLevelArr_two[p2] - _currentGrowArr[p2];

                    _propLevelArr_two[p2] = Math.Ceiling(_propLevelArr_two[p2] / 10) / 10;
                    _growLevelArr_two[p2] = Math.Ceiling(_growLevelArr_two[p2] / 10) / 10;
                }
                propArr = _propLevelArr_two;
                growArr = _growLevelArr_two;
            }
            else
            {
                for (int p3 = 0; p3 < _propLevelArr_three.Length; p3++)
                {
                    _propLevelArr_three[p3] = _propLevelArr_three[p3] + ((_petInfo.Level - 50) * _growLevelArr_three[p3] + 20 * _growLevelArr_two[p3] + 29 * _growLevelArr_one[p3] - _currentPropArr[p3]);
                    _growLevelArr_three[p3] = _growLevelArr_three[p3] - _currentGrowArr[p3];

                    _propLevelArr_three[p3] = Math.Ceiling(_propLevelArr_three[p3] / 10) / 10;
                    _growLevelArr_three[p3] = Math.Ceiling(_growLevelArr_three[p3] / 10) / 10;
                }
                propArr = _propLevelArr_three;
                growArr = _growLevelArr_three;
            }
        }

        public static double[] GetAddedPropArr(int grade, double[] propArr)
        {
            double[] arr = new double[5];
            arr[0] = propArr[0] * Math.Pow(2, grade - 1);
            for (int i = 1; i < 5; i++)
            {
                arr[i] = propArr[i] * Math.Pow(1.5, grade - 1);
            }
            return arr;
        }

        public static UsersPetInfo CreatePet(PetTemplateInfo info, int userID, int place, int playerLevel, int vipLv)
        {
            UsersPetInfo newPet = new UsersPetInfo();
            double star = info.StarLevel * 0.1;
            Random rd = new Random();

            newPet.BloodGrow = (int)(Math.Ceiling((double)(rd.Next((int)(info.HighBlood / (1.7 - star)), (info.HighBlood - (int)(info.HighBlood / 17.1))) / 10)));
            newPet.AttackGrow = rd.Next((int)(info.HighAttack / (1.7 - star)), (info.HighAttack - (int)(info.HighAttack / 17.1)));
            newPet.DefenceGrow = rd.Next((int)(info.HighDefence / (1.7 - star)), (info.HighDefence - (int)(info.HighDefence / 17.1)));
            newPet.AgilityGrow = rd.Next((int)(info.HighAgility / (1.7 - star)), (info.HighAgility - (int)(info.HighAgility / 17.1)));
            newPet.LuckGrow = rd.Next((int)(info.HighLuck / (1.7 - star)), (info.HighLuck - (int)(info.HighLuck / 17.1)));

            newPet.ID = 0;
            newPet.Hunger = 10000;
            newPet.TemplateID = info.TemplateID;
            newPet.Name = info.Name;
            newPet.UserID = userID;
            newPet.Place = place;
            newPet.Level = 1;
            newPet.BuildProp(newPet);
            newPet.Skill = UpdateSkillPet(1, info.TemplateID, playerLevel);
            newPet.SkillEquip = ActiveEquipSkill(1, vipLv);
            return newPet;
        }

        public static UsersPetInfo CreateNewPet(int vipLv)
        {
            string[] strId = FindConfig("NewPet").Value.Split(',');
            int index = rand.Next(strId.Length);
            PetTemplateInfo info = FindPetTemplate(Convert.ToInt32(strId[index]));
            return CreatePet(info, -1, -1, 60, vipLv);
        }
    }
}