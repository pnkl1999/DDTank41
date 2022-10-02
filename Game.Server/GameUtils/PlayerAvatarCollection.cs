using Bussiness;
using Game.Server.GameObjects;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.GameUtils
{
	public class PlayerAvatarCollection
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private List<UserAvatarCollectionInfo> m_avtcollect;

		protected object m_lock = new object();

		protected GamePlayer m_player;

		private bool m_saveToDb;

		public List<UserAvatarCollectionInfo> AvatarCollect
		{
			get
			{
				return this.m_avtcollect;
			}
			set
			{
				this.m_avtcollect = value;
			}
		}

		public GamePlayer Player
		{
			get
			{
				return this.m_player;
			}
		}

		public PlayerAvatarCollection(GamePlayer player, bool saveTodb)
		{
			this.m_player = player;
			this.m_saveToDb = saveTodb;
			this.m_avtcollect = new List<UserAvatarCollectionInfo>();
		}

		public void AddAvatarCollect(UserAvatarCollectionInfo info)
		{
			lock (this.m_avtcollect)
			{
				this.m_avtcollect.Add(info);
			}
		}

		public virtual void AddAvatarCollection(UserAvatarCollectionInfo avt)
		{
			lock (this.m_avtcollect)
			{
				if (this.GetAvatarCollectWithAvatarID(avt.AvatarID) == null)
				{
					this.m_avtcollect.Add(avt);
				}
			}
		}

		public virtual List<UserAvatarCollectionInfo> GetAvatarCollectActived()
		{
			List<UserAvatarCollectionInfo> result;
			lock (this.m_avtcollect)
			{
				List<UserAvatarCollectionInfo> list = new List<UserAvatarCollectionInfo>();
				if (this.m_avtcollect.Count > 0)
				{
					foreach (UserAvatarCollectionInfo current in this.m_avtcollect)
					{
						if (current.IsActive = current.IsExit)
						{
							list.Add(current);
						}
					}
				}
				result = list;
			}
			return result;
		}

		public virtual UserAvatarCollectionInfo GetAvatarCollectWithAvatarID(int avatarId)
		{
			UserAvatarCollectionInfo userAvatarCollectionInfo;
			UserAvatarCollectionInfo result;
			lock (this.m_avtcollect)
			{
				if (this.m_avtcollect.Count > 0)
				{
					foreach (UserAvatarCollectionInfo current in this.m_avtcollect)
					{
						if (current.AvatarID == avatarId && current.IsExit)
						{
							userAvatarCollectionInfo = current;
							result = userAvatarCollectionInfo;
							return result;
						}
					}
				}
				userAvatarCollectionInfo = null;
			}
			result = userAvatarCollectionInfo;
			return result;
		}

		public virtual UserAvatarCollectionInfo GetAvatarCollectWithAvatarID(int avatarId, int Sex)
		{
			UserAvatarCollectionInfo userAvatarCollectionInfo;
			UserAvatarCollectionInfo result;
			lock (this.m_avtcollect)
			{
				if (this.m_avtcollect.Count > 0)
				{
					foreach (UserAvatarCollectionInfo current in this.m_avtcollect)
					{
						if (current.AvatarID == avatarId && current.Sex == Sex && current.IsExit)
						{
							userAvatarCollectionInfo = current;
							result = userAvatarCollectionInfo;
							return result;
						}
					}
				}
				userAvatarCollectionInfo = null;
			}
			result = userAvatarCollectionInfo;
			return result;
		}

		public virtual List<UserAvatarCollectionInfo> GetAvatarPropertyActived()
		{
			List<UserAvatarCollectionInfo> result;
			lock (this.m_avtcollect)
			{
				List<UserAvatarCollectionInfo> list = new List<UserAvatarCollectionInfo>();
				List<UserAvatarCollectionInfo> avatarCollectActived = this.m_player.AvatarCollect.GetAvatarCollectActived();
				if (avatarCollectActived.Count > 0)
				{
					foreach (UserAvatarCollectionInfo current in avatarCollectActived)
					{
						ClothPropertyTemplateInfo clothPropertyWithID = ClothPropertyTemplateInfoMgr.GetClothPropertyWithID(current.AvatarID);
						if (clothPropertyWithID != null)
						{
							current.ClothProperty = clothPropertyWithID;
							list.Add(current);
						}
					}
				}
				result = list;
			}
			return result;
		}

		public virtual void LoadFromDatabase()
		{
			if (this.m_saveToDb)
			{
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					List<UserAvatarCollectionInfo> singleAvatarCollect = playerBussiness.GetSingleAvatarCollect(this.Player.PlayerCharacter.ID);
					if (singleAvatarCollect.Count > 0)
					{
						foreach (UserAvatarCollectionInfo current in singleAvatarCollect)
						{
							this.AddAvatarCollect(current);
						}
					}
				}
			}
		}

		public virtual bool RemoveAvatarCollect(UserAvatarCollectionInfo avt)
		{
			bool flag2;
			bool result;
			lock (this.m_avtcollect)
			{
				foreach (UserAvatarCollectionInfo current in this.m_avtcollect)
				{
					if (current == avt)
					{
						current.IsExit = false;
						flag2 = true;
						result = flag2;
						return result;
					}
				}
				flag2 = false;
			}
			result = flag2;
			return result;
		}

		public virtual void SaveToDatabase()
		{
			if (this.m_saveToDb)
			{
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					lock (this.m_lock)
					{
						for (int i = 0; i < this.m_avtcollect.Count; i++)
						{
							UserAvatarCollectionInfo userAvatarCollectionInfo = this.m_avtcollect[i];
							if (userAvatarCollectionInfo != null && userAvatarCollectionInfo.IsDirty)
							{
								if (userAvatarCollectionInfo.ID > 0)
								{
									playerBussiness.UpdateUserAvatarCollect(userAvatarCollectionInfo);
								}
								else if (userAvatarCollectionInfo.ID <= 0)
								{
									playerBussiness.AddUserAvatarCollect(userAvatarCollectionInfo);
								}
							}
						}
					}
				}
			}
		}

		public virtual void ScanAvatarVaildDate()
		{
			lock (this.m_avtcollect)
			{
				if (this.m_avtcollect.Count > 0)
				{
					int num = 0;
					foreach (UserAvatarCollectionInfo current in this.m_avtcollect)
					{
						if (current.IsActive && current.TimeEnd <= DateTime.Now && current.Items != null)
						{
							current.IsActive = false;
							num++;
						}
					}
					if (num > 0)
					{
						this.SaveToDatabase();
					}
				}
			}
		}
	}
}
