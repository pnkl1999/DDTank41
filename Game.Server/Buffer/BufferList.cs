using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.Buffer
{
    public class BufferList
    {
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private object m_lock;

        protected List<AbstractBuffer> m_buffers;

        protected List<int> m_bufferInfos;
        protected List<int> m_bufferCInfos;

		protected ArrayList m_clearList;

        protected volatile sbyte m_changesCount;

        private GamePlayer m_player;

        protected ArrayList m_changedBuffers;

        private int m_changeCount;

        public BufferList(GamePlayer player)
        {
			m_changedBuffers = new ArrayList();
			m_player = player;
			m_lock = new object();
			m_buffers = new List<AbstractBuffer>();
			m_clearList = new ArrayList();
			m_bufferInfos = new List<int>();
			m_bufferCInfos = new List<int>();
		}

        public void LoadFromDatabase(int playerId)
        {
			lock (m_lock)
			{
				using (PlayerBussiness db = new PlayerBussiness())
				{
					BufferInfo[] info = db.GetUserBuffer(playerId);
					BeginChanges();
					//BufferInfo[] array = info;
					for (int i = 0; i < info.Length; i++)
					{
						if(!IsConsortiaBuff1(info[i].Type) && !m_bufferInfos.Contains(info[i].Type))
                        {
							CreateBuffer(info[i])?.Start(m_player);
						}
					}
					ConsortiaBufferInfo[] comsortiaBuffs = db.GetUserConsortiaBuffer(m_player.PlayerCharacter.ConsortiaID);
					for (int j = 0; j < comsortiaBuffs.Length; j++)
					{
						if (!m_bufferCInfos.Contains(comsortiaBuffs[j].Type))
                        {
							CreateConsortiaBuffer(comsortiaBuffs[j])?.Start(m_player);
						}
					}
					CommitChanges();
				}
				Update();
				m_player.ClearFightBuffOneMatch();
			}
        }

        public void SaveToDatabase()
        {
			lock (m_lock)
			{
				using (PlayerBussiness pb = new PlayerBussiness())
                {
					foreach (AbstractBuffer buffer in m_buffers)
					{
						if (!IsConsortiaBuff1(buffer.Info.Type))
							pb.SaveBuffer(buffer.Info);
					}
					foreach (BufferInfo info in m_clearList)
					{
						pb.SaveBuffer(info);
					}
					m_clearList.Clear();
				}
			}
        }

        public bool AddBuffer(AbstractBuffer buffer)
        {
			lock (m_buffers)
			{
				if (!m_bufferInfos.Contains(buffer.Info.Type) && !m_bufferCInfos.Contains(buffer.Info.Type))
				{
					m_buffers.Add(buffer);
					if (IsConsortiaBuff(buffer.Info.Type))
						m_bufferCInfos.Add(buffer.Info.Type);
					else
						m_bufferInfos.Add(buffer.Info.Type);
				}
			}
			OnBuffersChanged(buffer);
			return true;
        }

        public bool RemoveBuffer(AbstractBuffer buffer)
        {
			lock (m_buffers)
			{
				if (m_buffers.Remove(buffer))
				{
					m_clearList.Add(buffer.Info);
				}
			}
			OnBuffersChanged(buffer);
			return true;
        }

        public void UpdateBuffer(AbstractBuffer buffer)
        {
			OnBuffersChanged(buffer);
        }

        protected void OnBuffersChanged(AbstractBuffer buffer)
        {
			if (!m_changedBuffers.Contains(buffer))
			{
				m_changedBuffers.Add(buffer);
			}
			if (m_changeCount <= 0 && m_changedBuffers.Count > 0)
			{
				UpdateChangedBuffers();
			}
        }

        public void BeginChanges()
        {
			Interlocked.Increment(ref m_changeCount);
        }

        public void CommitChanges()
        {
			int num = Interlocked.Decrement(ref m_changeCount);
			if (num < 0)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Inventory changes counter is bellow zero (forgot to use BeginChanges?)!\n\n" + Environment.StackTrace);
				}
				Thread.VolatileWrite(ref m_changeCount, 0);
			}
			if (num <= 0 && m_changedBuffers.Count > 0)
			{
				UpdateChangedBuffers();
			}
        }

        public void UpdateChangedBuffers()
        {
			List<AbstractBuffer> list = new List<AbstractBuffer>();
			Dictionary<string, BufferInfo> dictionary = new Dictionary<string, BufferInfo>();
			foreach (AbstractBuffer changedBuffer in m_changedBuffers)
			{
				list.Add(changedBuffer);
			}
			foreach (AbstractBuffer allBuffer in GetAllBuffers())
			{
				if (IsConsortiaBuff(allBuffer.Info.Type) && m_player.IsConsortia())
				{
					dictionary.Add(allBuffer.Info.Data, allBuffer.Info);
				}
			}
			GSPacketIn pkg = m_player.Out.SendUpdateBuffer(m_player, list.ToArray());
			if (m_player.CurrentRoom != null)
			{
				m_player.CurrentRoom.SendToAll(pkg, m_player);
			}
			m_player.Out.SendUpdateConsotiaBuffer(m_player, dictionary);
			m_changedBuffers.Clear();
			dictionary.Clear();
        }

        public List<AbstractBuffer> GetAllBuffers()
        {
			List<AbstractBuffer> list = new List<AbstractBuffer>();
			lock (m_lock)
			{
				foreach (AbstractBuffer buffer in m_buffers)
				{
					list.Add(buffer);
				}
				return list;
			}
        }

        public bool IsConsortiaBuff(int type)
        {
			if (type > 100)
			{
				return type < 115;
			}
			return false;
        }

		public bool IsConsortiaBuff1(int type)
		{
			switch (type)
			{
				case 102:
				case 104:
				case 105:
				case 107:
				case 109:
				case 110:
					return true;
				default:
					return false;
			}
		}

		public virtual AbstractBuffer GetOfType(Type bufferType)
        {
			lock (m_buffers)
			{
				foreach (AbstractBuffer buffer in m_buffers)
				{
					if (buffer.GetType().Equals(bufferType))
					{
						return buffer;
					}
				}
			}
			return null;
        }

        public virtual AbstractBuffer GetOfType(BuffType type)
        {
			lock (m_buffers)
			{
				foreach (AbstractBuffer buffer in m_buffers)
				{
					if (buffer.Info.Type == (int)type)
					{
						return buffer;
					}
				}
			}
			return null;
        }

        public virtual void ResetAllPayBuffer()
        {
			new List<AbstractBuffer>();
			lock (m_buffers)
			{
				foreach (AbstractBuffer buffer in m_buffers)
				{
					if (buffer.Check() && buffer.IsPayBuff())
					{
						ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(buffer.Info.TemplateID);
						buffer.Info.ValidCount = itemTemplateInfo.Property3;
						UpdateBuffer(buffer);
					}
				}
			}
        }

        public List<AbstractBuffer> GetAllBuffer()
        {
			List<AbstractBuffer> list = new List<AbstractBuffer>();
			lock (m_lock)
			{
				foreach (AbstractBuffer buffer in m_buffers)
				{
					list.Add(buffer);
				}
				return list;
			}
        }

        public void Update()
        {
			foreach (AbstractBuffer item in GetAllBuffer())
			{
				try
				{
					if (!item.Check())
					{
						item.Stop();
					}
				}
				catch (Exception message)
				{
					log.Error(message);
				}
			}
        }

        public static AbstractBuffer CreateBuffer(ItemTemplateInfo template, int ValidDate)
        {
			return CreateBuffer(new BufferInfo
			{
				BeginDate = DateTime.Now,
				ValidDate = ValidDate * 24 * 60,
				Value = template.Property2,
				Type = template.Property1,
				ValidCount = template.Property3,
				TemplateID = template.TemplateID,
				IsExist = true
			});
        }

        public static AbstractBuffer CreateConsortiaBuffer(ConsortiaBufferInfo info)
        {
			return CreateBuffer(new BufferInfo
			{
				Data = info.BufferID.ToString(),
				BeginDate = info.BeginDate,
				ValidDate = info.ValidDate,
				Value = info.Value,
				Type = info.Type,
				ValidCount = 1,
				IsExist = true
			});
        }

        public static AbstractBuffer CreatePayBuffer(ItemTemplateInfo template, int ValidDate)
        {
			BufferInfo bufferInfo = new BufferInfo();
			bufferInfo.Data = template.Property3.ToString();
			bufferInfo.BeginDate = DateTime.Now;
			bufferInfo.ValidDate = ValidDate;
			bufferInfo.Value = template.Property2;
			bufferInfo.Type = template.Property1;
			bufferInfo.ValidCount = template.Property3;
			bufferInfo.IsExist = true;
			return CreateBuffer(bufferInfo);
        }

        public static AbstractBuffer CreatePayBuffer(int type, int Value, int ValidMinutes, int id)
        {
			return CreateBuffer(new BufferInfo
			{
				Data = id.ToString(),
				BeginDate = DateTime.Now,
				ValidDate = ValidMinutes,
				Value = Value,
				Type = type,
				ValidCount = 1,
				IsExist = true
			});
        }

        public static AbstractBuffer CreateBufferHour(ItemTemplateInfo template, int ValidHour)
        {
			return CreateBuffer(new BufferInfo
			{
				BeginDate = DateTime.Now,
				ValidDate = ValidHour * 60,
				Value = template.Property2,
				Type = template.Property1,
				IsExist = true
			});
        }

        public static AbstractBuffer CreateBufferMinutes(ItemTemplateInfo template, int ValidMinutes)
        {
			return CreateBuffer(new BufferInfo
			{
				TemplateID = template.TemplateID,
				BeginDate = DateTime.Now,
				ValidDate = ValidMinutes,
				Value = template.Property2,
				Type = template.Property1,
				ValidCount = 1,
				IsExist = true
			});
        }

        public static AbstractBuffer CreateBuffer(BufferInfo info)
        {
            AbstractBuffer buffer = null;
            switch (info.Type)
            {
                case 11:
                    buffer = new KickProtectBuffer(info);
                    break;
                case 12:
                    buffer = new OfferMultipleBuffer(info);
                    break;
                case 13:
                    buffer = new GPMultipleBuffer(info);
                    break;
                case 15:
                    buffer = new PropsBuffer(info);
                    break;
                case 50:
                    buffer = new AgiBuffer(info);
                    break;
                case 51:
                    buffer = new SaveLifeBuffer(info);
                    break;
                case 52:
                    buffer = new ReHealthBuffer(info);
                    break;
                case 70:
                    buffer = new CaddyGoodsBuffer(info);
                    break;
                case 71:
                    buffer = new TrainGoodsBuffer(info);
                    break;
                case 72:
                    buffer = new LevelTry(info);
                    break;
                case 73:
                    buffer = new CardGetBuffer(info);
                    break;
                case 101:
                    buffer = new ConsortionAddBloodGunCountBuffer(info);
                    break;
                case 102:
                    buffer = new ConsortionAddDamageBuffer(info);
                    break;
                case 103:
                    buffer = new ConsortionAddCriticalBuffer(info);
                    break;
                case 104:
                    buffer = new ConsortionAddMaxBloodBuffer(info);
                    break;
                case 105:
                    buffer = new ConsortionAddPropertyBuffer(info);
                    break;
                case 106:
                    buffer = new ConsortionReduceEnergyUseBuffer(info);
                    break;
                case 107:
                    buffer = new ConsortionAddEnergyBuffer(info);
                    break;
                case 108:
                    buffer = new ConsortionAddEffectTurnBuffer(info);
                    break;
                case 109:
                    buffer = new ConsortionAddOfferRateBuffer(info);
                    break;
                case 110:
                    buffer = new ConsortionAddPercentGoldOrGPBuffer(info);
                    break;
                case 111:
                    buffer = new ConsortionAddSpellCountBuffer(info);
                    break;
                case 112:
                    buffer = new ConsortionReduceDanderBuffer(info);
                    break;
				case (int)BuffType.WorldBossHP:
					buffer = new WorldBossHPBuffer(info);
					break;
				case (int)BuffType.WorldBossAttrack:
					buffer = new WorldBossAttrackBuffer(info);
					break;
				case (int)BuffType.WorldBossHP_MoneyBuff:
					buffer = new WorldBossHP_MoneyBuffBuffer(info);
					break;
				case (int)BuffType.WorldBossAttrack_MoneyBuff:
					buffer = new WorldBossAttrack_MoneyBuffBuffer(info);
					break;
				case (int)BuffType.WorldBossMetalSlug:
					buffer = new WorldBossMetalSlugBuffer(info);
					break;
				case (int)BuffType.WorldBossAncientBlessings:
					buffer = new WorldBossAncientBlessingsBuffer(info);
					break;
				case (int)BuffType.WorldBossAddDamage:
					buffer = new WorldBossAddDamageBuffer(info);
					break;
				default:
					Console.WriteLine("CreateBuffer does not exist type: " + info.Type);
					break;
            }
            return buffer;
        }

        public List<AbstractBuffer> GetAllBufferByTemplate()
        {
			List<AbstractBuffer> list = new List<AbstractBuffer>();
			lock (m_lock)
			{
				foreach (AbstractBuffer buffer in m_buffers)
				{
					if (buffer.Info.TemplateID > 100)
					{
						list.Add(buffer);
					}
				}
				return list;
			}
        }

		public static AbstractBuffer CreatePayBuffer(int type, int Value, int ValidMinutes)
		{
			BufferInfo buffer = new BufferInfo();
			buffer.TemplateID = 0;
			buffer.BeginDate = DateTime.Now;
			buffer.ValidDate = ValidMinutes;
			buffer.Value = Value;
			buffer.Type = type;
			buffer.ValidCount = 1;
			buffer.IsExist = true;
			return CreateBuffer(buffer);
		}
    }
}
