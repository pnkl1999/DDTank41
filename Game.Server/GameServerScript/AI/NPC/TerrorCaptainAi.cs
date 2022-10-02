using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class TerrorCaptainAi : ABrain
    {
        private int m_attackTurn = 0;

        private List<SimpleNpc> Children = new List<SimpleNpc>();

        private int npcID = 1309;

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[] {
            "你们这是自寻死路！",

            "你惹毛我了!",

            "超级无敌大地震……<br/>震……震…… "
        };

        private static string[] ShootChat = new string[]{
            "砸你家玻璃。",

            "看哥打的可比你们准多了"
        };

        private static string[] KillPlayerChat = new string[]{
            "送你回老家！",

            "就凭你还妄想能够打败我？"
        };

        private static string[] CallChat = new string[]{
            "卫兵！ <br/>卫兵！！ ",
                  
            "啵咕们！！<br/>给我些帮助！"
        };

        private static string[] ShootedChat = new string[]{
            "哎呦！很痛…",

            "我还顶的住…"
        };

        private static string[] JumpChat = new string[]{
             "为了你们的胜利，<br/>向我开炮！",

             "你再往前半步我就把你给杀了！",

             "高！<br/>实在是高！"
        };

        private static string[] KillAttackChat = new string[]{
             "超级肉弹！！"
        };
        #endregion

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();

            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;
            Body.SetRect(((SimpleBoss)Body).NpcInfo.X, ((SimpleBoss)Body).NpcInfo.Y, ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Height);

            if (Body.Direction == -1)
            {
                Body.SetRect(((SimpleBoss)Body).NpcInfo.X, ((SimpleBoss)Body).NpcInfo.Y, ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Height);
            }
            else
            {
                Body.SetRect(-((SimpleBoss)Body).NpcInfo.X - ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Y, ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Height);
            }

        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 480 && player.X < 1000)
                {
                    int dis = (int)Body.Distance(player.X, player.Y);
                    if (dis > maxdis)
                    {
                        maxdis = dis;
                    }
                    result = true;
                }
            }

            if (result)
            {
                KillAttack(480, 1000);

                return;
            }

            if (m_attackTurn == 0)
            {
                AllAttack();
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                PersonalAttack();
                m_attackTurn++;
            }
            else
            {
                Summon();
                m_attackTurn = 0;
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        private void KillAttack(int fx, int tx)
        {
            ChangeDirection(3);
            int index = Game.Random.Next(0, KillAttackChat.Length);
            Body.Say(KillAttackChat[index], 1, 1000);
            Body.CurrentDamagePlus = 10;
            Body.PlayMovie("beat2", 3000, 0);
            Body.RangeAttacking(fx, tx, "cry", 5000, null);
        }

        private void AllAttack()
        {
            ChangeDirection(3);
            Body.CurrentDamagePlus = 0.5f;
            int index = Game.Random.Next(0, AllAttackChat.Length);
            Body.Say(AllAttackChat[index], 1, 0);
            Body.FallFrom(Body.X, 509, null, 1000, 1, 12);
            Body.PlayMovie("beat2", 1000, 0);
            Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "cry", 4000, null);
        }

        private void PersonalAttack()
        {
            ChangeDirection(3);
            int index = Game.Random.Next(0, ShootChat.Length);
            Body.Say(ShootChat[index], 1, 0);
            int dis = Game.Random.Next(670, 880);
            int direction = Body.Direction;
            Body.MoveTo(dis, Body.Y, "walk", 1000, "", ((SimpleBoss)Body).NpcInfo.speed, new LivingCallBack(NextAttack));
            Body.ChangeDirection(Game.FindlivingbyDir(Body), 9000);
        }

        private void Summon()
        {
            ChangeDirection(3);
            Body.JumpTo(Body.X, Body.Y - 300, "Jump", 1000, 1);
            int index = Game.Random.Next(0, CallChat.Length);
            Body.Say(CallChat[index], 1, 3300);
            Body.PlayMovie("call", 3500, 0);

            Body.CallFuction(new LivingCallBack(CreateChild), 4000);

        }

        private void NextAttack()
        {
            Player target = Game.FindRandomPlayer();
            if (target == null)
                return;
            Body.SetRect(0, 0, 0, 0);
            if (target.X > Body.Y)
            {
                Body.ChangeDirection(1, 500);
            }
            else
            {
                Body.ChangeDirection(-1, 500);
            }

            Body.CurrentDamagePlus = 0.8f;

            if (target != null)
            {
                int mtX = Game.Random.Next(target.X - 50, target.X + 50);

                if (Body.ShootPoint(mtX, target.Y, ((SimpleBoss)Body).NpcInfo.CurrentBallId, 1000, 10000, 1, 1, 2200))
                {
                    Body.PlayMovie("beat", 1700, 0);
                }

                if (Body.ShootPoint(mtX, target.Y, ((SimpleBoss)Body).NpcInfo.CurrentBallId, 1000, 10000, 1, 1, 3200))
                {
                    Body.PlayMovie("beat", 2700, 0);
                }
            }
        }

        private void ChangeDirection(int count)
        {
            int direction = Body.Direction;
            for (int i = 0; i < count; i++)
            {
                Body.ChangeDirection(-direction, i * 200 + 100);
                Body.ChangeDirection(direction, (i + 1) * 100 + i * 200);
            }
        }

        public void CreateChild()
        {
            ((SimpleBoss)Body).CreateChild(npcID, 520, 530, 430, 6,-1);
        }


    }
}
