using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;

namespace Game.Server.GameServerScript.AI.Game
{
    public class RunRunChickenNightmareGame : APVEGameControl
    {
        public override void OnCreated()
        {
            Game.SetupMissions("7401,7402,7403,7404");
            Game.TotalMissionCount = 4;           
        }

        public override void OnPrepated()
        {

            //Game.SessionId = 0;
        }

        public override int CalculateScoreGrade(int score)
        {
            if (score > 800)
            {
                return 3;
            }
            else if (score > 725)
            {
                return 2;
            }
            else if (score > 650)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        public override void OnGameOverAllSession()
        {
        }
    }
}
