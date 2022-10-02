using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.GameUtils
{
	public abstract class AbstractInventory
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		protected object m_lock = new object();
		private int m_type;
		private int m_capalility;
		private int m_beginSlot;
		private bool m_autoStack;
		protected ItemInfo[] m_items;
		protected List<int> m_changedPlaces = new List<int>();
		private int m_changeCount;
		public int BeginSlot
		{
			get
			{
				return this.m_beginSlot;
			}
		}
		public int Capalility
		{
			get
			{
				return this.m_capalility;
			}
			set
			{
				this.m_capalility = ((value < 0) ? 0 : ((value > this.m_items.Length) ? this.m_items.Length : value));
			}
		}
		public int BagType
		{
			get
			{
				return this.m_type;
			}
		}

		public bool IsEmpty(int slot)
		{
			return slot < 0 || slot >= this.m_capalility || this.m_items[slot] == null;
		}

		public AbstractInventory(int capability, int type, int beginSlot, bool autoStack)
		{
			this.m_capalility = capability;
			this.m_type = type;
			this.m_beginSlot = beginSlot;
			this.m_autoStack = autoStack;
			this.m_items = new ItemInfo[capability];
		}

		public virtual bool AddItem(ItemInfo item)
		{
			return this.AddItem(item, this.m_beginSlot);
		}

		public virtual bool AddItem(ItemInfo item, int minSlot)
		{
			if (item == null)
			{
				return false;
			}
			int place = this.FindFirstEmptySlot(minSlot);
			return this.AddItemTo(item, place);
		}

		public virtual bool AddItem(ItemInfo item, int minSlot, int maxSlot)
		{
			if (item == null)
			{
				return false;
			}
			int place = this.FindFirstEmptySlot(minSlot, maxSlot);
			return this.AddItemTo(item, place);
		}

		public virtual bool AddItemTo(ItemInfo item, int place)
		{
			if (item == null || place >= m_capalility || place < 0) return false;

			lock (m_lock)
			{
				if (m_items[place] != null)
				{
					place = -1;
				}
				else
				{
					m_items[place] = item;
					item.Place = place;
					item.BagType = m_type;
				}
			}
			if (place != -1)
				OnPlaceChanged(place);

			return place != -1;
		}

		public virtual bool TakeOutItem(ItemInfo item)
		{
			if (item == null) return false;
			int place = -1;
			lock (m_lock)
			{
				for (int i = 0; i < m_capalility; i++)
				{
					if (m_items[i] == item)
					{
						place = i;
						m_items[i] = null;
						break;
					}
				}
			}
			if (place != -1)
			{
				OnPlaceChanged(place);
				if (item.BagType == BagType)
				{
					item.Place = -1;
					item.BagType = -1;
					//return true;
				}
			}
			return place != -1;
		}

		public bool TakeOutItemAt(int place)
		{
			return this.TakeOutItem(this.GetItemAt(place));
		}

		public void RemoveAllItem(List<ItemInfo> items)
		{
			this.BeginChanges();
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				for (int i = 0; i < this.m_capalility; i++)
				{
					if (this.m_items[i] != null)
					{
						this.RemoveItem(this.m_items[i]);
					}
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			this.CommitChanges();
		}

		public void RemoveAllItem(List<int> places)
		{
			this.BeginChanges();
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				for (int i = 0; i < places.Count; i++)
				{
					int num = places[i];
					if (this.m_items[num] != null)
					{
						this.RemoveItem(this.m_items[num]);
					}
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			this.CommitChanges();
		}

		public virtual bool RemoveItem(ItemInfo item)
		{
			if (item == null)
			{
				return false;
			}
			int num = -1;
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				for (int i = 0; i < this.m_capalility; i++)
				{
					if (this.m_items[i] == item)
					{
						num = i;
						this.m_items[i] = null;
						break;
					}
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			if (num != -1)
			{
				this.OnPlaceChanged(num);
				if (item.BagType == this.BagType)
				{
					item.Place = -1;
					item.BagType = -1;
				}
			}
			return num != -1;
		}

		public bool RemoveItemAt(int place)
		{
			return this.RemoveItem(this.GetItemAt(place));
		}

		public virtual bool AddCountToStack(ItemInfo item, int count)
		{
			if (item == null)
			{
				return false;
			}
			if (count <= 0 || item.BagType != this.m_type)
			{
				return false;
			}
			if (item.Count + count > item.Template.MaxCount)
			{
				return false;
			}
			item.Count += count;
			this.OnPlaceChanged(item.Place);
			return true;
		}

		public virtual bool RemoveCountFromStack(ItemInfo item, int count)
		{
			if (item == null)
			{
				return false;
			}
			if (count <= 0 || item.BagType != this.m_type)
			{
				return false;
			}
			if (item.Count < count)
			{
				return false;
			}
			if (item.Count == count)
			{
				return this.RemoveItem(item);
			}
			item.Count -= count;
			this.OnPlaceChanged(item.Place);
			return true;
		}

		public virtual bool AddTemplateAt(ItemInfo cloneItem, int count, int place)
		{
			return this.AddTemplate(cloneItem, count, place, this.m_capalility - 1);
		}

		public virtual bool AddTemplate(ItemInfo cloneItem, int count)
		{
			return this.AddTemplate(cloneItem, count, this.m_beginSlot, this.m_capalility - 1);
		}

		public virtual bool AddTemplate(ItemInfo cloneItem)
		{
			return this.AddTemplate(cloneItem, cloneItem.Count, this.m_beginSlot, this.m_capalility - 1);
		}

		public virtual bool AddTemplate(ItemInfo cloneItem, int count, int minSlot, int maxSlot)
		{
			if (cloneItem == null)
			{
				return false;
			}
			ItemTemplateInfo template = cloneItem.Template;
			if (template == null)
			{
				return false;
			}
			if (count <= 0)
			{
				return false;
			}
			if (minSlot < this.m_beginSlot || minSlot > this.m_capalility - 1)
			{
				return false;
			}
			if (maxSlot < this.m_beginSlot || maxSlot > this.m_capalility - 1)
			{
				return false;
			}
			if (minSlot > maxSlot)
			{
				return false;
			}
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			bool result;
			try
			{
				List<int> list = new List<int>();
				int num = count;
				for (int i = minSlot; i <= maxSlot; i++)
				{
					ItemInfo itemInfo = this.m_items[i];
					if (itemInfo == null)
					{
						num -= template.MaxCount;
						list.Add(i);
					}
					else
					{
						if (this.m_autoStack && cloneItem.CanStackedTo(itemInfo))
						{
							num -= template.MaxCount - itemInfo.Count;
							list.Add(i);
						}
					}
					if (num <= 0)
					{
						break;
					}
				}
				if (num <= 0)
				{
					this.BeginChanges();
					try
					{
						num = count;
						foreach (int current in list)
						{
							ItemInfo itemInfo2 = this.m_items[current];
							if (itemInfo2 == null)
							{
								itemInfo2 = cloneItem.Clone();
								itemInfo2.Count = ((num < template.MaxCount) ? num : template.MaxCount);
								num -= itemInfo2.Count;
								this.AddItemTo(itemInfo2, current);
							}
							else
							{
								if (itemInfo2.TemplateID == template.TemplateID)
								{
									int num2 = (itemInfo2.Count + num < template.MaxCount) ? num : (template.MaxCount - itemInfo2.Count);
									itemInfo2.Count += num2;
									num -= num2;
									this.OnPlaceChanged(current);
								}
								else
								{
									AbstractInventory.log.Error("Add template erro: select slot's TemplateId not equest templateId");
								}
							}
						}
						if (num != 0)
						{
							AbstractInventory.log.Error("Add template error: last count not equal Zero.");
						}
					}
					finally
					{
						this.CommitChanges();
					}
					result = true;
				}
				else
				{
					result = false;
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return result;
		}

		public virtual bool RemoveTemplate(int templateId, int count)
		{
			return this.RemoveTemplate(templateId, count, 0, this.m_capalility - 1);
		}

		public virtual bool RemoveTemplate(int templateId, int count, int minSlot, int maxSlot)
		{
			if (count <= 0)
			{
				return false;
			}
			if (minSlot < 0 || minSlot > this.m_capalility - 1)
			{
				return false;
			}
			if (maxSlot <= 0 || maxSlot > this.m_capalility - 1)
			{
				return false;
			}
			if (minSlot > maxSlot)
			{
				return false;
			}
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			bool result;
			try
			{
				List<int> list = new List<int>();
				int num = count;
				for (int i = minSlot; i <= maxSlot; i++)
				{
					ItemInfo itemInfo = this.m_items[i];
					if (itemInfo != null && itemInfo.TemplateID == templateId)
					{
						list.Add(i);
						num -= itemInfo.Count;
						if (num <= 0)
						{
							break;
						}
					}
				}
				if (num <= 0)
				{
					this.BeginChanges();
					num = count;
					try
					{
						foreach (int current in list)
						{
							ItemInfo itemInfo2 = this.m_items[current];
							if (itemInfo2 != null && itemInfo2.TemplateID == templateId)
							{
								if (itemInfo2.Count <= num)
								{
									this.RemoveItem(itemInfo2);
									num -= itemInfo2.Count;
								}
								else
								{
									int num2 = (itemInfo2.Count - num < itemInfo2.Count) ? num : 0;
									itemInfo2.Count -= num2;
									num -= num2;
									this.OnPlaceChanged(current);
								}
							}
						}
						if (num != 0)
						{
							AbstractInventory.log.Error("Remove templat error:last itemcoutj not equal Zero.");
						}
					}
					finally
					{
						this.CommitChanges();
					}
					result = true;
				}
				else
				{
					result = false;
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return result;
		}

		public virtual bool MoveItem(int fromSlot, int toSlot, int count)
		{
			if (fromSlot < 0 || toSlot < 0 || fromSlot >= this.m_capalility || toSlot >= this.m_capalility)
			{
				return false;
			}
			bool flag = false;
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				flag = (this.CombineItems(fromSlot, toSlot) || this.StackItems(fromSlot, toSlot, count) || this.ExchangeItems(fromSlot, toSlot));
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			if (flag)
			{
				this.BeginChanges();
				try
				{
					this.OnPlaceChanged(fromSlot);
					this.OnPlaceChanged(toSlot);
				}
				finally
				{
					this.CommitChanges();
				}
			}
			return flag;
		}

		public bool IsSolt(int slot)
		{
			return slot >= 0 && slot < this.m_capalility;
		}

		public void ClearBag()
		{
			this.BeginChanges();
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				for (int i = this.m_beginSlot; i < this.m_capalility; i++)
				{
					if (this.m_items[i] != null)
					{
						this.RemoveItem(this.m_items[i]);
					}
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			this.CommitChanges();
		}

		public void ClearBagWithoutPlace(int place)
		{
			BeginChanges();
			lock (m_lock)
			{
				for (int i = this.m_beginSlot; i < this.m_capalility; i++)
				{
					if (m_items[i] != null && m_items[i].Place != place)
					{
						RemoveItem(m_items[i]);
					}
				}
			}
			CommitChanges();
		}

		public bool StackItemToAnother(ItemInfo item)
		{
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				for (int i = this.m_capalility - 1; i >= 0; i--)
				{
					if (item != null && this.m_items[i] != null && this.m_items[i] != item && item.CanStackedTo(this.m_items[i]) && this.m_items[i].Count + item.Count <= item.Template.MaxCount)
					{
						ItemInfo itemInfo = this.m_items[i];
						itemInfo.Count += item.Count;
						item.IsExist = false;
						item.RemoveType = 26;
						this.UpdateItem(this.m_items[i]);
						return true;
					}
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return false;
		}

		protected virtual bool CombineItems(int fromSlot, int toSlot)
		{
			return false;
		}

		protected virtual bool StackItems(int fromSlot, int toSlot, int itemCount)
		{
			ItemInfo itemInfo = this.m_items[fromSlot];
			ItemInfo itemInfo2 = this.m_items[toSlot];
			if (itemCount == 0)
			{
				if (itemInfo.Count > 0)
				{
					itemCount = itemInfo.Count;
				}
				else
				{
					itemCount = 1;
				}
			}
			if (itemInfo2 != null && itemInfo2.TemplateID == itemInfo.TemplateID && itemInfo2.CanStackedTo(itemInfo))
			{
				if (itemInfo.Count + itemInfo2.Count > itemInfo.Template.MaxCount)
				{
					itemInfo.Count -= itemInfo2.Template.MaxCount - itemInfo2.Count;
					itemInfo2.Count = itemInfo2.Template.MaxCount;
				}
				else
				{
					itemInfo2.Count += itemCount;
					this.RemoveItem(itemInfo);
				}
				return true;
			}
			if (itemInfo2 != null || itemInfo.Count <= itemCount)
			{
				return false;
			}
			ItemInfo itemInfo3 = itemInfo.Clone();
			itemInfo3.Count = itemCount;
			if (this.AddItemTo(itemInfo3, toSlot))
			{
				itemInfo.Count -= itemCount;
				return true;
			}
			return false;
		}

		protected virtual bool ExchangeItems(int fromSlot, int toSlot)
		{
			ItemInfo itemInfo = this.m_items[toSlot];
			ItemInfo itemInfo2 = this.m_items[fromSlot];
			this.m_items[fromSlot] = itemInfo;
			this.m_items[toSlot] = itemInfo2;
			if (itemInfo != null)
			{
				itemInfo.Place = fromSlot;
			}
			if (itemInfo2 != null)
			{
				itemInfo2.Place = toSlot;
			}
			return true;
		}

		public virtual ItemInfo GetItemAt(int slot)
		{
			if (slot < 0 || slot >= this.m_capalility)
			{
				return null;
			}
			return this.m_items[slot];
		}

		public int FindFirstEmptySlot()
		{
			return this.FindFirstEmptySlot(this.m_beginSlot);
		}

		public int FindFirstEmptySlot(int minSlot)
		{
			if (minSlot >= m_capalility) return -1;

			lock (m_lock)
			{
				for (int i = minSlot; i < m_capalility; i++)
				{
					if (m_items[i] == null)
					{
						return i;
					}
				}
				return -1;
			}
		}


		public int CountTotalEmptySlot()
		{
			return this.GetEmptyCount(this.m_beginSlot);
		}

		public int CountTotalEmptySlot(int minSlot)
		{
			if (minSlot < 0 || minSlot > this.m_capalility - 1)
			{
				return 0;
			}
			int num = 0;
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				for (int i = minSlot; i < this.m_capalility; i++)
				{
					if (this.m_items[i] == null)
					{
						num++;
					}
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return num;
		}

		public int FindFirstEmptySlot(int minSlot, int maxSlot)
		{
			if (minSlot >= maxSlot) return -1;

			lock (m_lock)
			{
				for (int i = minSlot; i < maxSlot; i++)
				{
					if (m_items[i] == null)
					{
						return i;
					}
				}
				return -1;
			}
		}

		public int FindLastEmptySlot()
		{
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			int result;
			try
			{
				for (int i = this.m_capalility - 1; i >= 0; i--)
				{
					if (this.m_items[i] == null)
					{
						result = i;
						return result;
					}
				}
				result = -1;
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return result;
		}

		public int FindLastEmptySlot(int maxSlot)
		{
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			int result;
			try
			{
				for (int i = maxSlot - 1; i >= 0; i--)
				{
					if (this.m_items[i] == null)
					{
						result = i;
						return result;
					}
				}
				result = -1;
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return result;
		}

		public virtual void Clear()
		{
			this.BeginChanges();
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				for (int i = 0; i < this.m_capalility; i++)
				{
					this.m_items[i] = null;
					this.OnPlaceChanged(i);
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			this.CommitChanges();
		}

		public virtual ItemInfo GetItemByCategoryID(int minSlot, int categoryID, int property)
		{
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			ItemInfo result;
			try
			{
				for (int i = minSlot; i < this.m_capalility; i++)
				{
					if (this.m_items[i] != null && this.m_items[i].Template.CategoryID == categoryID && (property == -1 || this.m_items[i].Template.Property1 == property))
					{
						result = this.m_items[i];
						return result;
					}
				}
				result = null;
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return result;
		}

		public virtual ItemInfo GetItemByTemplateID(int minSlot, int templateId)
		{
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			ItemInfo result;
			try
			{
				for (int i = minSlot; i < this.m_capalility; i++)
				{
					if (this.m_items[i] != null && this.m_items[i].TemplateID == templateId)
					{
						result = this.m_items[i];
						return result;
					}
				}
				result = null;
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return result;
		}

		public virtual List<ItemInfo> GetItemsByTemplateID(int minSlot, int templateid)
		{
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			List<ItemInfo> result;
			try
			{
				List<ItemInfo> list = new List<ItemInfo>();
				for (int i = minSlot; i < this.m_capalility; i++)
				{
					if (this.m_items[i] != null && this.m_items[i].TemplateID == templateid)
					{
						list.Add(this.m_items[i]);
					}
				}
				result = list;
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return result;
		}

		public virtual ItemInfo GetItemByItemID(int minSlot, int itemId)
		{
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			ItemInfo result;
			try
			{
				for (int i = minSlot; i < this.m_capalility; i++)
				{
					if (this.m_items[i] != null && this.m_items[i].ItemID == itemId)
					{
						result = this.m_items[i];
						return result;
					}
				}
				result = null;
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return result;
		}

		public virtual int GetItemCount(int templateId)
		{
			return this.GetItemCount(this.m_beginSlot, templateId);
		}

		public int GetItemCount(int minSlot, int templateId)
		{
			int num = 0;
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				for (int i = minSlot; i < this.m_capalility; i++)
				{
					if (this.m_items[i] != null && this.m_items[i].TemplateID == templateId)
					{
						num += this.m_items[i].Count;
					}
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return num;
		}

		public virtual List<ItemInfo> GetItems()
		{
			return this.GetItems(0, this.m_capalility);
		}

		public virtual List<ItemInfo> GetItems(int minSlot, int maxSlot)
		{
			List<ItemInfo> list = new List<ItemInfo>();
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				for (int i = minSlot; i < maxSlot; i++)
				{
					if (this.m_items[i] != null)
					{
						list.Add(this.m_items[i]);
					}
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return list;
		}

		public int GetEmptyCount()
		{
			return this.GetEmptyCount(this.m_beginSlot);
		}

		public virtual int GetEmptyCount(int minSlot)
		{
			if (minSlot < 0 || minSlot > this.m_capalility - 1)
			{
				return 0;
			}
			int num = 0;
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				for (int i = minSlot; i < this.m_capalility; i++)
				{
					if (this.m_items[i] == null)
					{
						num++;
					}
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return num;
		}

		public virtual void UseItem(ItemInfo item)
		{
			bool flag = false;
			if (!item.IsBinds && (item.Template.BindType == 2 || item.Template.BindType == 3))
			{
				item.IsBinds = true;
				flag = true;
			}
			if (!item.IsUsed)
			{
				item.IsUsed = true;
				item.BeginDate = DateTime.Now;
				flag = true;
			}
			if (flag)
			{
				this.OnPlaceChanged(item.Place);
			}
		}

		public virtual void UpdateItem(ItemInfo item)
		{
			if (item.BagType == m_type)
			{
				if (item.Count <= 0)
					RemoveItem(item);
				else
					OnPlaceChanged(item.Place);
			}
		}

		public virtual bool RemoveCountFromStack(ItemInfo item, int count, eItemRemoveType type)
		{
			if (item == null)
			{
				return false;
			}
			if (count <= 0 || item.BagType != this.m_type)
			{
				return false;
			}
			if (item.Count < count)
			{
				return false;
			}
			if (item.Count == count)
			{
				return this.RemoveItem(item);
			}
			item.Count -= count;
			this.OnPlaceChanged(item.Place);
			return true;
		}

		public virtual bool RemoveItem(ItemInfo item, eItemRemoveType type)
		{
			if (item == null)
			{
				return false;
			}
			int num = -1;
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			try
			{
				for (int i = 0; i < this.m_capalility; i++)
				{
					if (this.m_items[i] == item)
					{
						num = i;
						this.m_items[i] = null;
						break;
					}
				}
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			if (num != -1)
			{
				this.OnPlaceChanged(num);
				if (item.BagType == this.BagType && item.Place == num)
				{
					item.Place = -1;
					item.BagType = -1;
				}
			}
			return num != -1;
		}

		protected void OnPlaceChanged(int place)
		{
			if (!m_changedPlaces.Contains(place))
				m_changedPlaces.Add(place);

			if (m_changeCount <= 0 && m_changedPlaces.Count > 0)
			{
				UpdateChangedPlaces();
			}
		}

		public void BeginChanges()
		{
			Interlocked.Increment(ref this.m_changeCount);
		}

		public void CommitChanges()
		{
			int num = Interlocked.Decrement(ref this.m_changeCount);
			if (num < 0)
			{
				if (AbstractInventory.log.IsErrorEnabled)
				{
					AbstractInventory.log.Error("Inventory changes counter is bellow zero (forgot to use BeginChanges?)!\n\n" + Environment.StackTrace);
				}
				Thread.VolatileWrite(ref this.m_changeCount, 0);
			}
			if (num <= 0 && this.m_changedPlaces.Count > 0)
			{
				this.UpdateChangedPlaces();
			}
		}

		public virtual void UpdateChangedPlaces()
		{
			this.m_changedPlaces.Clear();
		}

		public ItemInfo[] GetRawSpaces()
		{
			object @lock;
			Monitor.Enter(@lock = this.m_lock);
			ItemInfo[] result;
			try
			{
				result = (this.m_items.Clone() as ItemInfo[]);
			}
			finally
			{
				Monitor.Exit(@lock);
			}
			return result;
		}

	}
}