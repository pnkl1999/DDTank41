using System;
using System.Collections.Generic;
using System.Linq;
using Bussiness;
using SqlDataProvider.Data;

namespace Game.Server.ConsortiaTask
{
    public class ConsortiaTaskData
    {
        private readonly List<ConsortiaTaskConditions>[,] consortiaTaskConditions = new List<ConsortiaTaskConditions>[5, 10];

        public void AddTask(ConsortiaTaskConditions consortiaTask)
        {
            //var Task = consortiaTaskConditions[consortiaTask.Type - 1, consortiaTask.Level - 1];
            //if (Task == null)
            //{
            //    Task = new List<ConsortiaTaskConditions>();
            //}
            //Task.Add(consortiaTask);
            var Task = consortiaTaskConditions[consortiaTask.Type - 1, consortiaTask.Level - 1];
            if (Task == null)
            {
                Task = new List<ConsortiaTaskConditions>();
            }
            Task.Add(consortiaTask);
            consortiaTaskConditions[consortiaTask.Type - 1, consortiaTask.Level - 1] = Task;
        }

        public ConsortiaTaskConditions GetTaskConditionDataInfo(int type, int level)
        {
            var Task = consortiaTaskConditions[type - 1, level - 1];
            Task.Shuffle();
            return Task.Random();
        }
    }
}