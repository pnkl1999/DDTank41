using Game.Server.ConsortiaTask.Conditions;
using Game.Server.GameObjects;
using SqlDataProvider.Data;
using System.Collections.Generic;
using Game.Server.ConsortiaTask.Data;

namespace Game.Server.ConsortiaTask
{
    public class Consortia
    {
        public int ID
        {
            get;
            set;
        }
        public ConsortiaTaskInfo Task
        {
            get;
            set;
        }
        public List<GamePlayer> Players
        {
            get;
            set;
        }

        public List<Condition> Conditions
        {
            get;
            set;
        }

        public Dictionary<int, int> RankTable
        {
            get;
            set;
        }
    }
}
