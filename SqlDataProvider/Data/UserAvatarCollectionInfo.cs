using System;
using System.Collections.Generic;

namespace SqlDataProvider.Data
{
	public class UserAvatarCollectionInfo : DataObject
	{
		private int _AvatarID;

		private ClothPropertyTemplateInfo _clothProperty;

		private string _data;

		private int _ID;

		private bool _isActive;

		private bool _IsExit;

		private List<UserAvatarCollectionDataInfo> _items;

		private int _Sex;

		private DateTime _timeend;

		private DateTime _timeStart;

		private int _userID;

		public int AvatarID
		{
			get
			{
				return this._AvatarID;
			}
			set
			{
				this._AvatarID = value;
				this._isDirty = true;
			}
		}

		public ClothPropertyTemplateInfo ClothProperty
		{
			get
			{
				return this._clothProperty;
			}
			set
			{
				this._clothProperty = value;
			}
		}

		public string Data
		{
			get
			{
				return this._data;
			}
			set
			{
				this._data = value;
				this._isDirty = true;
			}
		}

		public int ID
		{
			get
			{
				return this._ID;
			}
			set
			{
				this._ID = value;
				this._isDirty = true;
			}
		}

		public bool IsActive
		{
			get
			{
				return this._isActive;
			}
			set
			{
				this._isActive = value;
				this._isDirty = true;
			}
		}

		public bool IsExit
		{
			get
			{
				return this._IsExit;
			}
			set
			{
				this._IsExit = value;
				this._isDirty = true;
			}
		}

		public List<UserAvatarCollectionDataInfo> Items
		{
			get
			{
				if (this._items == null)
				{
					this._items = this.GetData();
				}
				return this._items;
			}
			set
			{
				this._items = value;
			}
		}

		public int Sex
		{
			get
			{
				return this._Sex;
			}
			set
			{
				this._Sex = value;
				this._isDirty = true;
			}
		}

		public DateTime TimeEnd
		{
			get
			{
				return this._timeend;
			}
			set
			{
				this._timeend = value;
				this._isDirty = true;
			}
		}

		public DateTime TimeStart
		{
			get
			{
				return this._timeStart;
			}
			set
			{
				this._timeStart = value;
				this._isDirty = true;
			}
		}

		public int UserID
		{
			get
			{
				return this._userID;
			}
			set
			{
				this._userID = value;
				this._isDirty = true;
			}
		}

		public UserAvatarCollectionInfo()
		{
		}

		public UserAvatarCollectionInfo(int UserId, int AvatarID, int Sex, bool IsActive, DateTime timeend)
		{
			this._userID = UserId;
			this._AvatarID = AvatarID;
			this._Sex = Sex;
			this._isActive = IsActive;
			this._timeend = timeend;
			this._timeStart = DateTime.Now;
			this._data = "";
			this._IsExit = true;
		}

		public bool ActiveAvatar(int days)
		{
			bool result;
			if (days <= 0)
			{
				result = false;
			}
			else if (this._isActive && this._timeend >= DateTime.Now)
			{
				this.TimeEnd = this.TimeEnd.AddDays((double)days);
				result = true;
			}
			else
			{
				this.IsActive = true;
				this.TimeEnd = DateTime.Now.AddDays((double)days);
				result = true;
			}
			return result;
		}

		public bool AddItem(UserAvatarCollectionDataInfo item)
		{
			if (this._items == null)
			{
				this._items = this.GetData();
			}
			bool result;
			if (this.GetItemWithTemplateID(item.TemplateID) == null)
			{
				this.Items.Add(item);
				this.SaveData();
				result = true;
			}
			else
			{
				result = false;
			}
			return result;
		}

		public List<UserAvatarCollectionDataInfo> GetData()
		{
			List<UserAvatarCollectionDataInfo> list = new List<UserAvatarCollectionDataInfo>();
			if (this._data == null)
			{
				this._data = "";
			}
			List<UserAvatarCollectionDataInfo> list2;
			List<UserAvatarCollectionDataInfo> result;
			if (this._data.Length > 0)
			{
				string[] array = this._data.Split(new char[]
				{
					'|'
				});
				if (array.Length <= 0)
				{
					list2 = list;
					result = list2;
					return result;
				}
				string[] array2 = array;
				for (int i = 0; i < array2.Length; i++)
				{
					string text = array2[i];
					string[] array3 = text.Split(new char[]
					{
						','
					});
					if (array3.Length >= 2)
					{
						UserAvatarCollectionDataInfo item = new UserAvatarCollectionDataInfo
						{
							TemplateID = int.Parse(array3[0]),
							Sex = int.Parse(array3[1])
						};
						list.Add(item);
					}
				}
			}
			list2 = list;
			result = list2;
			return result;
		}

		public UserAvatarCollectionDataInfo GetItemWithTemplateID(int ItemID)
		{
			if (this._items == null)
			{
				this._items = this.GetData();
			}
			UserAvatarCollectionDataInfo userAvatarCollectionDataInfo;
			UserAvatarCollectionDataInfo result;
			if (this._items.Count > 0)
			{
				foreach (UserAvatarCollectionDataInfo current in this._items)
				{
					if (current.TemplateID == ItemID)
					{
						userAvatarCollectionDataInfo = current;
						result = userAvatarCollectionDataInfo;
						return result;
					}
				}
			}
			userAvatarCollectionDataInfo = null;
			result = userAvatarCollectionDataInfo;
			return result;
		}

		public bool IsAvailable()
		{
			return this._isActive && this._timeend > DateTime.Now;
		}

		public bool RemoveItem(UserAvatarCollectionDataInfo item)
		{
			if (this._items == null)
			{
				this._items = this.GetData();
			}
			bool result;
			if (this.GetItemWithTemplateID(item.TemplateID) != null)
			{
				this.Items.Remove(item);
				this.SaveData();
				result = true;
			}
			else
			{
				result = false;
			}
			return result;
		}

		public bool SaveData()
		{
			bool result = false;
			if (this._items == null)
			{
				this._items = this.GetData();
			}
			string[] array = new string[2];
			List<string> list = new List<string>();
			if (this._items.Count > 0)
			{
				foreach (UserAvatarCollectionDataInfo current in this._items)
				{
					array[0] = current.TemplateID.ToString();
					array[1] = current.Sex.ToString();
					string item = string.Join(",", array);
					list.Add(item);
				}
				if (list.Count > 0)
				{
					string data = string.Join("|", list.ToArray());
					this.Data = data;
					result = true;
				}
			}
			return result;
		}

		public void UpdateItems()
		{
			if (this._items == null)
			{
				this._items = this.GetData();
			}
		}
	}
}
