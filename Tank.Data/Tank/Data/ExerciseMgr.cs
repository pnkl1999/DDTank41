// Decompiled with JetBrains decompiler
// Type: Tank.Data.ExerciseMgr
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using Helpers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace Tank.Data
{
  public class ExerciseMgr
  {
    private static Dictionary<int, ExerciseInfo> m_exercises = new Dictionary<int, ExerciseInfo>();

    public static bool Init() => ExerciseMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ExerciseInfo> dictionary = ExerciseMgr.LoadFromDatabase();
        if (dictionary.Values.Count > 0)
        {
          Interlocked.Exchange<Dictionary<int, ExerciseInfo>>(ref ExerciseMgr.m_exercises, dictionary);
          return true;
        }
      }
      catch (Exception ex)
      {
        Logger.Error("ExerciseMgr init error:" + ex.ToString());
      }
      return false;
    }

    private static Dictionary<int, ExerciseInfo> LoadFromDatabase()
    {
      Dictionary<int, ExerciseInfo> dictionary = new Dictionary<int, ExerciseInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ExerciseInfo exerciseInfo in produceBussiness.GetAllExercise())
        {
          if (!dictionary.ContainsKey(exerciseInfo.Grage))
            dictionary.Add(exerciseInfo.Grage, exerciseInfo);
        }
      }
      return dictionary;
    }

    public static List<ExerciseInfo> GetAllExercise()
    {
      if (ExerciseMgr.m_exercises.Count == 0)
        ExerciseMgr.Init();
      return ExerciseMgr.m_exercises.Values.ToList<ExerciseInfo>();
    }

    public static ExerciseInfo FindExercise(int id)
    {
      if (ExerciseMgr.m_exercises.Count == 0)
        ExerciseMgr.Init();
      return ExerciseMgr.m_exercises.ContainsKey(id) ? ExerciseMgr.m_exercises[id] : (ExerciseInfo) null;
    }
  }
}
