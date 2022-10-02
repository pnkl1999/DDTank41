using Game.Server.GameObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Game.Server.ConsortiaTask.Data;
using SqlDataProvider.Data;

namespace Game.Server.ConsortiaTask.Conditions
{
    public abstract class Condition
    {
        public readonly GamePlayer Player;
        public readonly Consortia Consortia;

        protected Condition(GamePlayer player, Consortia consortia)
        {
            Player = player;
            Consortia = consortia;
        }

        public virtual void AddTrigger()
        {

        }
        public virtual void RemoveTrigger()
        {

        }

        public void Update(ConsortiaTaskConditionInfo condition)
        {
            foreach (var consortiaPlayer in Consortia.Players)
            {
                ConsortiaTaskMgr.Out.SendTaskUpdate(consortiaPlayer, condition);
                ConsortiaTaskMgr.SaveConsortiaTask(Consortia);
            }
        }
    }
}
