using Bussiness;
using Bussiness.Managers;
using Bussiness.Protocol;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace Game.Logic
{
	public class DropInventory
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private static ThreadSafeRandom random = new ThreadSafeRandom();

		public static int roundDate = 0;

		public static bool AnswerDrop(int answerId, ref List<ItemInfo> info)
		{
			int dropId = GetDropCondiction(eDropType.Answer, answerId.ToString(), "0");
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.Answer, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		public static bool BossDrop(int missionId, ref List<ItemInfo> info)
		{
			int dropId = GetDropCondiction(eDropType.Boss, missionId.ToString(), "0");
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.Boss, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		public static bool BoxDrop(eRoomType e, ref List<ItemInfo> info)
		{
			int num = (int)e;
			int dropId = GetDropCondiction(eDropType.Box, num.ToString(), "0");
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.Box, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		public static bool CardDrop(eRoomType e, ref List<ItemInfo> info)
		{
			int num = (int)e;
			int dropId = GetDropCondiction(eDropType.Cards, num.ToString(), "0");
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.Cards, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		public static bool GetPetDrop(int copyId, int user, ref List<PetTemplateInfo> info)
		{
			int dropId = GetDropCondiction(eDropType.Trminhpc, copyId.ToString(), user.ToString());
			if (dropId > 0)
			{
				List<PetTemplateInfo> infos = null;
				if (GetDropPets(eDropType.Trminhpc, dropId, ref infos))
				{
					info = ((infos != null) ? infos : null);
					return true;
				}
			}
			return false;
		}

		public static bool CopyAllDrop(int copyId, ref List<ItemInfo> info)
		{
			int dropId = GetDropCondiction(eDropType.Copy, copyId.ToString(), "0");
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetAllDropItems(eDropType.Copy, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		public static bool CopyDrop(int copyId, int user, ref List<ItemInfo> info)
		{
			int dropId = GetDropCondiction(eDropType.Copy, copyId.ToString(), user.ToString());
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.Copy, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		public static List<ItemInfo> CopySystemDrop(int copyId, int OpenCount)
		{
			int num4 = Convert.ToInt32((double)OpenCount * 0.1);
			int num5 = Convert.ToInt32((double)OpenCount * 0.3);
			int num6 = OpenCount - num4 - num5;
			List<ItemInfo> list = new List<ItemInfo>();
			List<ItemInfo> itemInfos = null;
			int dropId = GetDropCondiction(eDropType.Copy, copyId.ToString(), "2");
			if (dropId > 0)
			{
				for (int num3 = 0; num3 < num4; num3++)
				{
					if (GetDropItems(eDropType.Copy, dropId, ref itemInfos))
					{
						list.Add(itemInfos[0]);
						itemInfos = null;
					}
				}
			}
			int num7 = GetDropCondiction(eDropType.Copy, copyId.ToString(), "3");
			if (num7 > 0)
			{
				for (int num2 = 0; num2 < num5; num2++)
				{
					if (GetDropItems(eDropType.Copy, num7, ref itemInfos))
					{
						list.Add(itemInfos[0]);
						itemInfos = null;
					}
				}
			}
			int num8 = GetDropCondiction(eDropType.Copy, copyId.ToString(), "4");
			if (num8 > 0)
			{
				for (int num = 0; num < num6; num++)
				{
					if (GetDropItems(eDropType.Copy, num8, ref itemInfos))
					{
						list.Add(itemInfos[0]);
						itemInfos = null;
					}
				}
			}
			return RandomSortList(list);
		}

		public static bool FireDrop(eRoomType e, ref List<ItemInfo> info)
		{
			int num = (int)e;
			int dropId = GetDropCondiction(eDropType.Fire, num.ToString(), "0");
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.Fire, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		private static bool GetAllDropItems(eDropType type, int dropId, ref List<ItemInfo> itemInfos)
		{
			if (dropId != 0)
			{
				try
				{
					int count = 1;
					List<DropItem> list = DropMgr.FindDropItem(dropId);
					int maxRound = ThreadSafeRandom.NextStatic(list.Select((DropItem s) => s.Random).Max());
					int num2 = list.Where((DropItem s) => s.Random >= maxRound).ToList().Count();
					if (num2 == 0)
					{
						return false;
					}
					count = ((count > num2) ? num2 : count);
					GetRandomUnrepeatArray(0, num2 - 1, count);
					foreach (DropItem item in list)
					{
						int num3 = ThreadSafeRandom.NextStatic(item.BeginData, item.EndData);
						ItemTemplateInfo goods = ItemMgr.FindItemTemplate(item.ItemId);
						ItemInfo info2 = ItemInfo.CreateFromTemplate(goods, num3, 101);
						if (info2 != null)
						{
							info2.IsBinds = item.IsBind;
							info2.ValidDate = item.ValueDate;
							info2.IsTips = item.IsTips;
							info2.IsLogs = item.IsLogs;
							if (itemInfos == null)
							{
								itemInfos = new List<ItemInfo>();
							}
							if (DropInfoMgr.CanDrop(goods.TemplateID))
							{
								itemInfos.Add(info2);
							}
						}
					}
					return true;
				}
				catch
				{
					if (log.IsErrorEnabled)
					{
						log.Error(string.Concat("Drop Error：", type, " dropId ", dropId));
					}
				}
			}
			return false;
		}

		public static bool GetDrop(int copyId, int user, ref List<ItemInfo> info)
		{
			int dropId = GetDropCondiction(eDropType.Trminhpc, copyId.ToString(), user.ToString());
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.Trminhpc, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		private static int GetDropCondiction(eDropType type, string para1, string para2)
		{
			try
			{
				return DropMgr.FindCondiction(type, para1, para2);
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error(string.Concat("Drop Error：", type, " @ ", exception));
				}
			}
			return 0;
		}

		private static bool GetDropItems(eDropType type, int dropId, ref List<ItemInfo> itemInfos)
		{
			if (dropId != 0)
			{
				try
				{
					int count = 1;
					List<DropItem> list = DropMgr.FindDropItem(dropId);
					int maxRound = ThreadSafeRandom.NextStatic(list.Select((DropItem s) => s.Random).Max());
					List<DropItem> source = list.Where((DropItem s) => s.Random >= maxRound).ToList();
					int num2 = source.Count();
					if (num2 == 0)
					{
						return false;
					}
					count = ((count > num2) ? num2 : count);
					int[] randomUnrepeatArray = GetRandomUnrepeatArray(0, num2 - 1, count);
					int[] array = randomUnrepeatArray;
					foreach (int num3 in array)
					{
						int num4 = ThreadSafeRandom.NextStatic(source[num3].BeginData, source[num3].EndData);
						ItemTemplateInfo goods = ItemMgr.FindItemTemplate(source[num3].ItemId);
						ItemInfo item = ItemInfo.CreateFromTemplate(goods, num4, 101);
						if (item != null)
						{
							item.IsBinds = source[num3].IsBind;
							item.ValidDate = source[num3].ValueDate;
							item.IsTips = source[num3].IsTips;
							item.IsLogs = source[num3].IsLogs;
							if (itemInfos == null)
							{
								itemInfos = new List<ItemInfo>();
							}
							if (DropInfoMgr.CanDrop(goods.TemplateID))
							{
								itemInfos.Add(item);
							}
						}
					}
					return true;
				}
				catch
				{
					if (log.IsErrorEnabled)
					{
						log.Error(string.Concat("Drop Error：", type, " dropId ", dropId));
					}
				}
			}
			return false;
		}

		private static bool GetDropPets(eDropType type, int dropId, ref List<PetTemplateInfo> petInfos)
		{
			if (dropId == 0)
			{
				return false;
			}
			try
			{
				int dropItemCount = 1;
				List<DropItem> unFiltItems = DropMgr.FindDropItem(dropId);
				int maxRound = ThreadSafeRandom.NextStatic(unFiltItems.Select((DropItem s) => s.Random).Max());
				List<DropItem> filtItems = unFiltItems.Where((DropItem s) => s.Random >= maxRound).ToList();
				int maxItems = filtItems.Count();
				if (maxItems == 0)
				{
					return false;
				}
				dropItemCount = ((dropItemCount > maxItems) ? maxItems : dropItemCount);
				int[] randomArray = GetRandomUnrepeatArray(0, maxItems - 1, dropItemCount);
				int[] array = randomArray;
				foreach (int i in array)
				{
					int itemCount = ThreadSafeRandom.NextStatic(filtItems[i].BeginData, filtItems[i].EndData);
					PetTemplateInfo temp = PetMgr.FindPetTemplate(filtItems[i].ItemId);
					if (temp != null)
					{
						if (petInfos == null)
						{
							petInfos = new List<PetTemplateInfo>();
						}
						if (DropInfoMgr.CanDrop(temp.TemplateID))
						{
							petInfos.Add(temp);
						}
					}
				}
				return true;
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Drop Error：" + type.ToString() + " @ " + ex);
				}
			}
			return false;
		}

		public static int[] GetRandomUnrepeatArray(int minValue, int maxValue, int count)
		{
			int[] numArray = new int[count];
			for (int i = 0; i < count; i++)
			{
				int num2 = ThreadSafeRandom.NextStatic(minValue, maxValue + 1);
				int num3 = 0;
				for (int j = 0; j < i; j++)
				{
					if (numArray[j] == num2)
					{
						num3++;
					}
				}
				if (num3 == 0)
				{
					numArray[i] = num2;
				}
				else
				{
					i--;
				}
			}
			return numArray;
		}

		public static bool NPCDrop(int dropId, ref List<ItemInfo> info)
		{
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.NPC, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		public static bool PvEQuestsDrop(int npcId, ref List<ItemInfo> info)
		{
			int dropId = GetDropCondiction(eDropType.PveQuests, npcId.ToString(), "0");
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.PveQuests, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		public static bool PvPQuestsDrop(eRoomType e, bool playResult, ref List<ItemInfo> info)
		{
			int num = (int)e;
			int dropId = GetDropCondiction(eDropType.PvpQuests, num.ToString(), Convert.ToInt16(playResult).ToString());
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.PvpQuests, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		public static List<ItemInfo> RandomSortList(List<ItemInfo> list)
		{
			return list.OrderBy((ItemInfo key) => random.Next()).ToList();
		}

		public static bool RetrieveDrop(int user, ref List<ItemInfo> info)
		{
			int dropId = GetDropCondiction(eDropType.Retrieve, user.ToString(), "0");
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.Retrieve, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		public static bool SpecialDrop(int missionId, int boxType, ref List<ItemInfo> info)
		{
			int dropId = GetDropCondiction(eDropType.Special, missionId.ToString(), boxType.ToString());
			if (dropId > 0)
			{
				List<ItemInfo> itemInfos = null;
				if (GetDropItems(eDropType.Special, dropId, ref itemInfos))
				{
					info = ((itemInfos != null) ? itemInfos : null);
					return true;
				}
			}
			return false;
		}

		public static bool FightLabUserDrop(int copyId, ref List<ItemInfo> info)
		{
			int dropId = GetDropCondiction(eDropType.FightLab, copyId.ToString(), "1");
			if (dropId > 0)
			{
				List<DropItem> unFiltItems = DropMgr.FindDropItem(dropId);
				for (int i = 0; i < unFiltItems.Count; i++)
				{
					int itemCount = random.Next(unFiltItems[i].BeginData, unFiltItems[i].EndData);
					ItemInfo item = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(unFiltItems[i].ItemId), itemCount, copyId);
					if (item != null)
					{
						item.IsBinds = unFiltItems[i].IsBind;
						item.ValidDate = unFiltItems[i].ValueDate;
						item.IsTips = unFiltItems[i].IsTips;
						item.IsLogs = unFiltItems[i].IsLogs;
						if (info == null)
						{
							info = new List<ItemInfo>();
						}
						info.Add(item);
					}
				}
				return true;
			}
			return false;
		}
	}
}