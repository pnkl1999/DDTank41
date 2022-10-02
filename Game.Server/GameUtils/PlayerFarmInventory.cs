using Bussiness;
using Bussiness.Managers;
using Game.Logic;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.GameUtils
{
    public abstract class PlayerFarmInventory
    {
        protected object m_lock = new object();

        protected bool m_midAutumnFlag;

        private int m_capalility;

        private int m_beginSlot;

        protected UserFarmInfo m_farm;

        protected UserFieldInfo[] m_fields;

        protected UserFarmInfo m_otherFarm;

        protected UserFieldInfo[] m_otherFields;

        protected int m_farmstatus;

        public UserFarmInfo OtherFarm=> m_otherFarm;

        public UserFieldInfo[] OtherFields=> m_otherFields;

        public UserFarmInfo CurrentFarm=> m_farm;

        public UserFieldInfo[] CurrentFields=> m_fields;

        public int Status=> m_farmstatus;

        public PlayerFarmInventory(int capability, int beginSlot)
        {
			m_capalility = capability;
			m_beginSlot = beginSlot;
			m_fields = new UserFieldInfo[capability];
			m_otherFields = new UserFieldInfo[capability];
			m_farmstatus = 0;
        }

        public int ripeNum()
        {
			int num = 0;
			lock (m_lock)
			{
				for (int i = 0; i < m_fields.Length; i++)
				{
					if (m_fields[i] != null && m_fields[i].SeedID != 0)
					{
						num++;
					}
				}
			}
			return num;
        }

        public virtual void GropFastforward(bool isAllField, int fieldId)
        {
			lock (m_lock)
			{
				if (isAllField)
				{
					for (int i = 0; i < m_fields.Length; i++)
					{
						if (m_fields[i] != null && m_fields[i].SeedID != 0)
						{
							m_fields[i].AccelerateTime += GameProperties.FastGrowSubTime;
						}
					}
				}
				else if (m_fields[fieldId] != null && m_fields[fieldId].SeedID != 0)
				{
					m_fields[fieldId].AccelerateTime += GameProperties.FastGrowSubTime;
				}
			}
        }

        public bool AddField(UserFieldInfo item)
        {
			return AddField(item, m_beginSlot);
        }

        public bool AddField(UserFieldInfo item, int minSlot)
        {
			if (item == null)
			{
				return false;
			}
			int place = FindFirstEmptySlot(minSlot);
			return AddFieldTo(item, place);
        }

        public virtual bool AddFieldTo(UserFieldInfo item, int place)
        {
			if (item == null || place >= m_capalility || place < 0)
			{
				return false;
			}
			lock (m_lock)
			{
				m_fields[place] = item;
				if (m_fields[place] != null)
				{
					place = -1;
				}
				else
				{
					m_fields[place] = item;
					item.FieldID = place;
				}
			}
			return place != -1;
        }

        public virtual bool AddOtherFieldTo(UserFieldInfo item, int place)
        {
			if (item == null || place >= m_capalility || place < 0)
			{
				return false;
			}
			lock (m_lock)
			{
				m_otherFields[place] = item;
				if (m_otherFields[place] != null)
				{
					place = -1;
				}
				else
				{
					m_otherFields[place] = item;
					item.FieldID = place;
				}
			}
			return place != -1;
        }

        public virtual bool RemoveOtherField(UserFieldInfo item)
        {
			if (item == null)
			{
				return false;
			}
			int num = -1;
			lock (m_lock)
			{
				for (int i = 0; i < m_capalility; i++)
				{
					if (m_otherFields[i] == item)
					{
						num = i;
						m_otherFields[i] = null;
						break;
					}
				}
			}
			return num != -1;
        }

        public virtual UserFieldInfo GetFieldAt(int slot)
        {
			if (slot < 0 || slot >= m_capalility)
			{
				return null;
			}
			return m_fields[slot];
        }

        public int FindFirstEmptySlot(int minSlot)
        {
			if (minSlot >= m_capalility)
			{
				return -1;
			}
			lock (m_lock)
			{
				for (int i = minSlot; i < m_capalility; i++)
				{
					if (m_fields[i] == null)
					{
						return i;
					}
				}
				return -1;
			}
        }

        public void ClearOtherFields()
        {
			lock (m_lock)
			{
				for (int i = m_beginSlot; i < m_capalility; i++)
				{
					if (m_otherFields[i] != null)
					{
						RemoveOtherField(m_otherFields[i]);
					}
				}
			}
        }

        public virtual void ResetFarmProp()
        {
			lock (m_lock)
			{
				if (m_farm != null)
				{
					m_farm.isArrange = false;
					m_farm.buyExpRemainNum = 20;
				}
			}
        }

        public virtual void ClearIsArrange()
        {
			lock (m_lock)
			{
				m_farm.isArrange = true;
			}
        }

        public virtual void UpdateGainCount(int fieldId, int count)
        {
			lock (m_lock)
			{
				m_fields[fieldId].GainCount = count;
			}
        }

        public virtual void UpdateFarm(UserFarmInfo farm)
        {
			lock (m_lock)
			{
				m_farm = farm;
			}
        }

        public virtual void UpdateOtherFarm(UserFarmInfo farm)
        {
			lock (m_lock)
			{
				m_otherFarm = farm;
			}
        }

        public virtual bool GrowField(int fieldId, int templateID)
        {
			ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(templateID);
			lock (m_lock)
			{
				m_fields[fieldId].SeedID = itemTemplateInfo.TemplateID;
				m_fields[fieldId].PlantTime = DateTime.Now;
				m_fields[fieldId].GainCount = itemTemplateInfo.Property2;
				m_fields[fieldId].FieldValidDate = itemTemplateInfo.Property3;
			}
			return true;
        }

        public virtual bool killCropField(int fieldId)
        {
			lock (m_lock)
			{
				if (m_fields[fieldId] != null)
				{
					m_fields[fieldId].SeedID = 0;
					m_fields[fieldId].FieldValidDate = 1;
					m_fields[fieldId].AccelerateTime = 0;
					m_fields[fieldId].GainCount = 0;
					return true;
				}
			}
			return false;
        }

        public virtual void CreateFarm(int ID, string name)
        {
			string value = PetMgr.FindConfig("PayFieldMoney").Value;
			string value2 = PetMgr.FindConfig("PayAutoMoney").Value;
			UserFarmInfo userFarmInfo = new UserFarmInfo();
			userFarmInfo.ID = 0;
			userFarmInfo.FarmID = ID;
			userFarmInfo.FarmerName = name;
			userFarmInfo.isFarmHelper = false;
			userFarmInfo.isAutoId = 0;
			userFarmInfo.AutoPayTime = DateTime.Now;
			userFarmInfo.AutoValidDate = 0;
			userFarmInfo.GainFieldId = 0;
			userFarmInfo.KillCropId = 0;
			userFarmInfo.PayAutoMoney = value2;
			userFarmInfo.PayFieldMoney = value;
			userFarmInfo.buyExpRemainNum = 20;
			userFarmInfo.isArrange = false;
			userFarmInfo.TreeLevel = 0;
			userFarmInfo.TreeExp = 0;
			userFarmInfo.LoveScore = 0;
			userFarmInfo.MonsterExp = 0;
			userFarmInfo.PoultryState = 0;
			userFarmInfo.CountDownTime = DateTime.Now;
			userFarmInfo.TreeCostExp = 0;
			UpdateFarm(userFarmInfo);
			CreateNewField(ID, 0, 8);
        }

        public virtual bool HelperSwitchFields(bool isHelper, int seedID, int seedTime, int haveCount, int getCount)
        {
			if (isHelper)
			{
				lock (m_lock)
				{
					for (int i = 0; i < m_fields.Length; i++)
					{
						if (m_fields[i] != null)
						{
							m_fields[i].SeedID = 0;
							m_fields[i].FieldValidDate = 1;
							m_fields[i].AccelerateTime = 0;
							m_fields[i].GainCount = 0;
						}
					}
				}
			}
			lock (m_lock)
			{
				m_farm.isFarmHelper = isHelper;
				m_farm.isAutoId = seedID;
				m_farm.AutoPayTime = DateTime.Now;
				m_farm.AutoValidDate = seedTime;
				m_farm.GainFieldId = getCount / 10;
				m_farm.KillCropId = getCount;
			}
			return true;
        }

        public virtual void CreateNewField(int ID, int minslot, int maxslot)
        {
			for (int i = minslot; i < maxslot; i++)
			{
				UserFieldInfo userFieldInfo = new UserFieldInfo();
				userFieldInfo.ID = 0;
				userFieldInfo.FarmID = ID;
				userFieldInfo.FieldID = i;
				userFieldInfo.SeedID = 0;
				userFieldInfo.PayTime = DateTime.Now.AddYears(100);
				userFieldInfo.payFieldTime = 876000;
				userFieldInfo.PlantTime = DateTime.Now;
				userFieldInfo.GainCount = 0;
				userFieldInfo.FieldValidDate = 1;
				userFieldInfo.AccelerateTime = 0;
				userFieldInfo.AutomaticTime = DateTime.Now;
				userFieldInfo.IsExit = true;
				AddFieldTo(userFieldInfo, i);
			}
        }

        public virtual bool CreateField(int ID, List<int> fieldIds, int payFieldTime)
        {
			for (int i = 0; i < fieldIds.Count; i++)
			{
				int num = fieldIds[i];
				if (m_fields[num] == null)
				{
					UserFieldInfo userFieldInfo = new UserFieldInfo();
					userFieldInfo.FarmID = ID;
					userFieldInfo.FieldID = num;
					userFieldInfo.SeedID = 0;
					userFieldInfo.PayTime = DateTime.Now.AddDays(payFieldTime / 24);
					userFieldInfo.payFieldTime = payFieldTime;
					userFieldInfo.PlantTime = DateTime.Now;
					userFieldInfo.GainCount = 0;
					userFieldInfo.FieldValidDate = 1;
					userFieldInfo.AccelerateTime = 0;
					userFieldInfo.AutomaticTime = DateTime.Now;
					userFieldInfo.IsExit = true;
					AddFieldTo(userFieldInfo, num);
				}
				else
				{
					m_fields[num].PayTime = DateTime.Now.AddDays(payFieldTime / 24);
					m_fields[num].payFieldTime = payFieldTime;
				}
			}
			return true;
        }

        public virtual UserFieldInfo[] GetFields()
        {
			List<UserFieldInfo> list = new List<UserFieldInfo>();
			lock (m_lock)
			{
				for (int i = 0; i < m_capalility; i++)
				{
					if (m_fields[i] != null && m_fields[i].IsValidField())
					{
						list.Add(m_fields[i]);
					}
				}
			}
			return list.ToArray();
        }

        public virtual UserFieldInfo[] GetOtherFields()
        {
			List<UserFieldInfo> list = new List<UserFieldInfo>();
			lock (m_lock)
			{
				for (int i = 0; i < m_capalility; i++)
				{
					if (m_otherFields[i] != null && m_otherFields[i].IsValidField())
					{
						list.Add(m_otherFields[i]);
					}
				}
			}
			return list.ToArray();
        }

        public virtual UserFieldInfo GetOtherFieldAt(int slot)
        {
			if (slot < 0 || slot >= m_capalility)
			{
				return null;
			}
			return m_otherFields[slot];
        }

        public virtual int GetEmptyCount(int minSlot)
        {
			if (minSlot < 0 || minSlot > m_capalility - 1)
			{
				return 0;
			}
			int num = 0;
			lock (m_lock)
			{
				for (int i = minSlot; i < m_capalility; i++)
				{
					if (m_fields[i] == null)
					{
						num++;
					}
				}
			}
			return num;
        }

        public virtual int payFieldMoneyToWeek()
        {
			return int.Parse(m_farm.PayFieldMoney.Split('|')[0].Split(',')[1]);
        }

        public virtual int payFieldMoneyToMonth()
        {
			return int.Parse(m_farm.PayFieldMoney.Split('|')[1].Split(',')[1]);
        }

        public virtual int payFieldTimeToMonth()
        {
			return int.Parse(m_farm.PayFieldMoney.Split('|')[1].Split(',')[0]);
        }

        public virtual int payAutoTimeToMonth()
        {
			return int.Parse(m_farm.PayAutoMoney.Split('|')[1].Split(',')[0]);
        }

        public virtual UserFarmInfo CreateFarmForNulll(int ID)
        {
			UserFarmInfo userFarmInfo = new UserFarmInfo();
			userFarmInfo.FarmID = ID;
			userFarmInfo.FarmerName = "Null";
			userFarmInfo.isFarmHelper = false;
			userFarmInfo.isAutoId = 0;
			userFarmInfo.AutoPayTime = DateTime.Now;
			userFarmInfo.AutoValidDate = 0;
			userFarmInfo.GainFieldId = 0;
			userFarmInfo.KillCropId = 0;
			userFarmInfo.isArrange = true;
			return userFarmInfo;
        }

        public virtual UserFieldInfo[] CreateFieldsForNull(int ID)
        {
			List<UserFieldInfo> list = new List<UserFieldInfo>();
			for (int i = 0; i < 8; i++)
			{
				UserFieldInfo userFieldInfo = new UserFieldInfo();
				userFieldInfo.FarmID = ID;
				userFieldInfo.FieldID = i;
				userFieldInfo.SeedID = 0;
				userFieldInfo.PayTime = DateTime.Now;
				userFieldInfo.payFieldTime = 365000;
				userFieldInfo.PlantTime = DateTime.Now;
				userFieldInfo.GainCount = 0;
				userFieldInfo.FieldValidDate = 1;
				userFieldInfo.AccelerateTime = 0;
				userFieldInfo.AutomaticTime = DateTime.Now;
				list.Add(userFieldInfo);
			}
			return list.ToArray();
        }
    }
}
