using Bussiness;
using Game.Server.Packets;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace Game.Server.GameUtils
{
	public class PlayerInventory : AbstractInventory
	{
		protected GamePlayer m_player;
		private bool m_saveToDb;
		private List<ItemInfo> m_removedList = new List<ItemInfo>();

		private bool bool_1;

		private List<ItemInfo> list_0;

		public GamePlayer Player
		{
			get
			{
				return this.m_player;
			}
		}

		public PlayerInventory(GamePlayer player, bool saveTodb, int capibility, int type, int beginSlot, bool autoStack)
			: base(capibility, type, beginSlot, autoStack)
		{
			list_0 = new List<ItemInfo>();
			this.m_player = player;
			this.m_saveToDb = saveTodb;
			bool_1 = saveTodb;
		}

		public virtual void LoadFromDatabase()
		{
			if (this.m_saveToDb)
			{
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					ItemInfo[] userBagByType = playerBussiness.GetUserBagByType(this.m_player.PlayerCharacter.ID, base.BagType);
					base.BeginChanges();
					try
					{
						ItemInfo[] array = userBagByType;
						for (int i = 0; i < array.Length; i++)
						{
							ItemInfo itemInfo = array[i];
							if (this.IsWrongPlace(itemInfo) && itemInfo.Place < 31 && base.BagType == 0)
							{
								int num = this.FindFirstEmptySlot(31);
								if (num != -1)
								{
									this.MoveItem(itemInfo.Place, num, itemInfo.Count);
								}
								else
								{
									this.m_player.AddTemplate(itemInfo);
								}
							}
							else
							{
								this.AddItemTo(itemInfo, itemInfo.Place);
							}
						}
					}
					finally
					{
						base.CommitChanges();
					}
				}
			}
		}

		public bool IsWrongPlace(ItemInfo item)
		{
			return item != null && item.Template != null && ((item.Template.CategoryID == 7 && item.Place != 6) || (item.Template.CategoryID == 27 && item.Place != 6) || (item.Template.CategoryID == 17 && item.Place != 15) || (item.Template.CategoryID == 31 && item.Place != 15));
		}

		public virtual void SaveToDatabase()
		{
			if (this.m_saveToDb)
			{
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					object @lock;
					Monitor.Enter(@lock = this.m_lock);
					try
					{
						for (int i = 0; i < this.m_items.Length; i++)
						{
							ItemInfo itemInfo = this.m_items[i];
							if (itemInfo != null && itemInfo.IsDirty)
							{
								if (itemInfo.ItemID > 0)
								{
									playerBussiness.UpdateGoods(itemInfo);
								}
								else
								{
									playerBussiness.AddGoods(itemInfo);
								}
							}
						}
					}
					finally
					{
						Monitor.Exit(@lock);
					}
					List<ItemInfo> removedList;
					Monitor.Enter(removedList = this.m_removedList);
					try
					{
						foreach (ItemInfo current in this.m_removedList)
						{
							if (current.ItemID > 0)
							{
								playerBussiness.UpdateGoods(current);
							}
						}
						this.m_removedList.Clear();
					}
					finally
					{
						Monitor.Exit(removedList);
					}
				}
			}
		}

		public virtual void SaveRemovedItems()
		{
			if (this.m_saveToDb)
			{
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					List<ItemInfo> removedList;
					Monitor.Enter(removedList = this.m_removedList);
					try
					{
						foreach (ItemInfo current in this.m_removedList)
						{
							if (current.ItemID > 0)
							{
								playerBussiness.UpdateGoods(current);
							}
						}
						this.m_removedList.Clear();
					}
					finally
					{
						Monitor.Exit(removedList);
					}
				}
			}
		}

		public virtual void SaveNewsItemIntoDatabas()
		{
			if (this.m_saveToDb)
			{
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					object @lock;
					Monitor.Enter(@lock = this.m_lock);
					try
					{
						for (int i = 0; i < this.m_items.Length; i++)
						{
							ItemInfo itemInfo = this.m_items[i];
							if (itemInfo != null && itemInfo.IsDirty && itemInfo.ItemID == 0)
							{
								playerBussiness.AddGoods(itemInfo);
							}
						}
					}
					finally
					{
						Monitor.Exit(@lock);
					}
				}
			}
		}

		public override bool AddItemTo(ItemInfo item, int place)
		{
			if (base.AddItemTo(item, place))
			{
				item.UserID = this.m_player.PlayerCharacter.ID;
				item.IsExist = true;
				return true;
			}
			//item.UserID = 0;
			//item.IsExist = true;
			return false;
		}

		public override bool TakeOutItem(ItemInfo item)
		{
			if (base.TakeOutItem(item))
			{
				if (this.m_saveToDb)
				{
					List<ItemInfo> removedList;
					Monitor.Enter(removedList = this.m_removedList);
					try
					{
						this.m_removedList.Add(item);
					}
					finally
					{
						Monitor.Exit(removedList);
					}
				}
				return true;
			}
			return false;
		}

		public override bool RemoveItem(ItemInfo item)
		{
			if (base.RemoveItem(item))
			{
				item.IsExist = false;
				if (this.m_saveToDb)
				{
					List<ItemInfo> removedList;
					Monitor.Enter(removedList = this.m_removedList);
					try
					{
						this.m_removedList.Add(item);
					}
					finally
					{
						Monitor.Exit(removedList);
					}
				}
				return true;
			}
			return false;
		}

		public override void UpdateChangedPlaces()
		{
			int[] updatedSlots = this.m_changedPlaces.ToArray();
			this.m_player.Out.SendUpdateInventorySlot(this, updatedSlots);
			base.UpdateChangedPlaces();
		}

		public bool SendAllItemsToMail(string sender, string title, eMailType type)
		{
			if (this.m_saveToDb)
			{
				base.BeginChanges();
				try
				{
					using (PlayerBussiness playerBussiness = new PlayerBussiness())
					{
						object @lock;
						Monitor.Enter(@lock = this.m_lock);
						try
						{
							List<ItemInfo> items = this.GetItems();
							int count = items.Count;
							for (int i = 0; i < count; i += 5)
							{
								MailInfo mailInfo = new MailInfo();
								mailInfo.SenderID = 0;
								mailInfo.Sender = sender;
								mailInfo.ReceiverID = this.m_player.PlayerCharacter.ID;
								mailInfo.Receiver = this.m_player.PlayerCharacter.NickName;
								mailInfo.Title = title;
								mailInfo.Type = (int)type;
								mailInfo.Content = "";
								List<ItemInfo> list = new List<ItemInfo>();
								for (int j = 0; j < 5; j++)
								{
									int num = i * 5 + j;
									if (num < items.Count)
									{
										list.Add(items[num]);
									}
								}
								if (!this.SendItemsToMail(list, mailInfo, playerBussiness))
								{
									return false;
								}
							}
						}
						finally
						{
							Monitor.Exit(@lock);
						}
					}
				}
				catch (Exception arg)
				{
					Console.WriteLine("Send Items Mail Error:" + arg);
				}
				finally
				{
					this.SaveToDatabase();
					base.CommitChanges();
				}
				this.m_player.Out.SendMailResponse(this.m_player.PlayerCharacter.ID, eMailRespose.Receiver);
				return true;
			}
			return true;
		}

		public bool SendItemsToMail(List<ItemInfo> items, MailInfo mail, PlayerBussiness pb)
		{
			if (mail == null)
			{
				return false;
			}
			if (items.Count > 5)
			{
				return false;
			}
			if (this.m_saveToDb)
			{
				List<ItemInfo> list = new List<ItemInfo>();
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(LanguageMgr.GetTranslation("Game.Server.GameUtils.CommonBag.AnnexRemark", new object[0]));
				if (items.Count > 0 && this.TakeOutItem(items[0]))
				{
					ItemInfo itemInfo = items[0];
					mail.Annex1 = itemInfo.ItemID.ToString();
					mail.Annex1Name = itemInfo.Template.Name;
					stringBuilder.Append(string.Concat(new object[]
					{
						"1、",
						mail.Annex1Name,
						"x",
						itemInfo.Count,
						";"
					}));
					list.Add(itemInfo);
				}
				if (items.Count > 1 && this.TakeOutItem(items[1]))
				{
					ItemInfo itemInfo2 = items[1];
					mail.Annex2 = itemInfo2.ItemID.ToString();
					mail.Annex2Name = itemInfo2.Template.Name;
					stringBuilder.Append(string.Concat(new object[]
					{
						"2、",
						mail.Annex2Name,
						"x",
						itemInfo2.Count,
						";"
					}));
					list.Add(itemInfo2);
				}
				if (items.Count > 2 && this.TakeOutItem(items[2]))
				{
					ItemInfo itemInfo3 = items[2];
					mail.Annex3 = itemInfo3.ItemID.ToString();
					mail.Annex3Name = itemInfo3.Template.Name;
					stringBuilder.Append(string.Concat(new object[]
					{
						"3、",
						mail.Annex3Name,
						"x",
						itemInfo3.Count,
						";"
					}));
					list.Add(itemInfo3);
				}
				if (items.Count > 3 && this.TakeOutItem(items[3]))
				{
					ItemInfo itemInfo4 = items[3];
					mail.Annex4 = itemInfo4.ItemID.ToString();
					mail.Annex4Name = itemInfo4.Template.Name;
					stringBuilder.Append(string.Concat(new object[]
					{
						"4、",
						mail.Annex4Name,
						"x",
						itemInfo4.Count,
						";"
					}));
					list.Add(itemInfo4);
				}
				if (items.Count > 4 && this.TakeOutItem(items[4]))
				{
					ItemInfo itemInfo5 = items[4];
					mail.Annex5 = itemInfo5.ItemID.ToString();
					mail.Annex5Name = itemInfo5.Template.Name;
					stringBuilder.Append(string.Concat(new object[]
					{
						"5、",
						mail.Annex5Name,
						"x",
						itemInfo5.Count,
						";"
					}));
					list.Add(itemInfo5);
				}
				mail.AnnexRemark = stringBuilder.ToString();
				if (pb.SendMail(mail))
				{
					return true;
				}
				foreach (ItemInfo current in list)
				{
					this.AddItem(current);
				}
			}
			return false;
		}

		public bool SendItemToMail(ItemInfo item)
		{
			if (this.m_saveToDb)
			{
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					return this.SendItemToMail(item, playerBussiness, null);
				}
				return false;
			}
			return false;
		}

		public bool SendItemToMail(ItemInfo item, PlayerBussiness pb, MailInfo mail)
		{
			if (!this.m_saveToDb || item.BagType != base.BagType)
			{
				return false;
			}
			if (mail == null)
			{
				mail = new MailInfo();
				mail.Annex1 = item.ItemID.ToString();
				mail.Content = LanguageMgr.GetTranslation("Game.Server.GameUtils.Title", new object[0]);
				mail.Gold = 0;
				mail.IsExist = true;
				mail.Money = 0;
				mail.Receiver = this.m_player.PlayerCharacter.NickName;
				mail.ReceiverID = item.UserID;
				mail.Sender = this.m_player.PlayerCharacter.NickName;
				mail.SenderID = item.UserID;
				mail.Title = LanguageMgr.GetTranslation("Game.Server.GameUtils.Title", new object[0]);
				mail.Type = 9;
			}
			if (pb.SendMail(mail))
			{
				this.RemoveItem(item);
				item.IsExist = true;
				return true;
			}
			return false;
		}
	}
}