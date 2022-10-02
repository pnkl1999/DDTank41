using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Game.Logic
{
    public class ExerciseMgr
    {
        private static Dictionary<int, ExerciseInfo> _exercises;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock;

        private static ThreadSafeRandom rand;

        private static List<EliteGameRoundInfo> list_0 = new List<EliteGameRoundInfo>();

        private static Dictionary<int, PlayerEliteGameInfo> dictionary_1 = new Dictionary<int, PlayerEliteGameInfo>();

        public static int EliteStatus { get; set; }

        public static Dictionary<int, PlayerEliteGameInfo> EliteGameChampionPlayersList=> dictionary_1;

        public static ExerciseInfo FindExercise(int Grage)
        {
			if (Grage == 0)
			{
				Grage = 1;
			}
			m_lock.AcquireReaderLock(10000);
			try
			{
				if (_exercises.ContainsKey(Grage))
				{
					return _exercises[Grage];
				}
			}
			catch
			{
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static int GetExercise(int GP, string type)
        {
			int exerciseL = 0;
			for (int i = 1; i <= GetMaxLevel(); i++)
			{
				if (FindExercise(i).GP >= GP)
				{
					return exerciseL;
				}
				if (type == null)
				{
					continue;
				}
				if (type != "A")
				{
					if (type != "AG")
					{
						if (type != "D")
						{
							if (type != "H")
							{
								if (type == "L")
								{
									exerciseL = FindExercise(i).ExerciseL;
								}
							}
							else
							{
								exerciseL = FindExercise(i).ExerciseH;
							}
						}
						else
						{
							exerciseL = FindExercise(i).ExerciseD;
						}
					}
					else
					{
						exerciseL = FindExercise(i).ExerciseAG;
					}
				}
				else
				{
					exerciseL = FindExercise(i).ExerciseA;
				}
			}
			return exerciseL;
        }

        public static int GetMaxLevel()
        {
			if (_exercises == null)
			{
				Init();
			}
			return _exercises.Values.Count;
        }

        public static int getLv(int exp)
        {
			int lv = 0;
			ExerciseInfo t = null;
			int i;
			for (i = 1; i <= GetMaxLevel(); i++)
			{
				t = _exercises[i];
				if (exp < t.GP)
				{
					break;
				}
				lv = i;
				i++;
			}
			return lv;
        }

        public static int getExp(int type, TexpInfo self)
        {
			return type switch
			{
				0 => self.hpTexpExp, 
				1 => self.attTexpExp, 
				2 => self.defTexpExp, 
				3 => self.spdTexpExp, 
				4 => self.lukTexpExp, 
				_ => 0, 
			};
        }

        public static bool isUp(int type, int oldExp, TexpInfo self)
        {
			if (getLv(getExp(type, self)) > getLv(oldExp))
			{
				return true;
			}
			return false;
        }

        public static bool Init()
        {
			try
			{
				m_lock = new ReaderWriterLock();
				_exercises = new Dictionary<int, ExerciseInfo>();
				rand = new ThreadSafeRandom();
				EliteStatus = 0;
				return LoadExercise(_exercises);
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ExercisesMgr", exception);
				}
				return false;
			}
        }

        private static bool LoadExercise(Dictionary<int, ExerciseInfo> Exercise)
        {
			using (ProduceBussiness bussiness = new ProduceBussiness())
			{
				ExerciseInfo[] allExercise = bussiness.GetAllExercise();
				ExerciseInfo[] array = allExercise;
				foreach (ExerciseInfo info in array)
				{
					if (!Exercise.ContainsKey(info.Grage))
					{
						Exercise.Add(info.Grage, info);
					}
				}
			}
			return true;
        }

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, ExerciseInfo> exercise = new Dictionary<int, ExerciseInfo>();
				if (LoadExercise(exercise))
				{
					m_lock.AcquireWriterLock(-1);
					try
					{
						_exercises = exercise;
						return true;
					}
					catch
					{
					}
					finally
					{
						m_lock.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ExerciseMgr", exception);
				}
			}
			return false;
        }

        public static void ResetEliteGame()
        {
			list_0 = new List<EliteGameRoundInfo>();
			dictionary_1 = new Dictionary<int, PlayerEliteGameInfo>();
        }

        public static void SynEliteGameChampionPlayerList(Dictionary<int, PlayerEliteGameInfo> tempPlayerList)
        {
			m_lock.AcquireReaderLock(-1);
			try
			{
				dictionary_1 = tempPlayerList;
			}
			catch
			{
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
        }

        public static void UpdateEliteGameChapionPlayerList(PlayerEliteGameInfo p)
        {
			m_lock.AcquireReaderLock(-1);
			try
			{
				if (dictionary_1.ContainsKey(p.UserID))
				{
					dictionary_1[p.UserID] = p;
				}
				else
				{
					dictionary_1.Add(p.UserID, p);
				}
			}
			catch
			{
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
        }

        public static EliteGameRoundInfo FindEliteRoundByUser(int userId)
        {
			m_lock.AcquireReaderLock(-1);
			try
			{
				foreach (EliteGameRoundInfo eliteGameRoundInfo in list_0.OrderByDescending((EliteGameRoundInfo a) => a.RoundType).ToList())
				{
					if (eliteGameRoundInfo.PlayerOne.UserID == userId || eliteGameRoundInfo.PlayerTwo.UserID == userId)
					{
						return eliteGameRoundInfo;
					}
				}
			}
			catch (Exception ex)
			{
				log.Error(ex.ToString());
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static void AddEliteRound(EliteGameRoundInfo elite)
        {
			m_lock.AcquireReaderLock(-1);
			try
			{
				list_0.Add(elite);
			}
			catch
			{
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
        }

        public static void RemoveEliteRound(EliteGameRoundInfo elite)
        {
			m_lock.AcquireReaderLock(-1);
			try
			{
				if (list_0.Contains(elite))
				{
					list_0.Remove(elite);
				}
			}
			catch
			{
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
        }

        public static bool IsBlockWeapon(int templateid)
        {
			bool flag = false;
			if (GameProperties.EliteGameBlockWeapon.Split('|').Contains(templateid.ToString()))
			{
				flag = true;
			}
			return flag;
        }
    }
}
