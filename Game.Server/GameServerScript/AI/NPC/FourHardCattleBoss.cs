using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class FourHardCattleBoss : ABrain
    {
        private int m_attackTurn = 0;

        private PhysicalObj m_effectAttack = null;

        private PhysicalObj m_powerUpEffect = null;

        private int m_totalNpc = 4;

        private int npcId = 4207;

        private float m_perPowerUp = 0.5f;

        private int m_reduceStreng = 100;

        private bool IsFear = false;

        private Player target = null;

        private float lastpowDamage = 0;

        private float m_currentPowDamage = 0;

        private string[] AllAtackPlayerSay =
        {
            "Các ngươi đỡ được không?",
            "Chết chắc rồi bọn ngu si!",
            "Sao mà đỡ lại được đây?",
            "Sao? Sao? Chết đi!!!!!"
        };

        private string[] SpecialAttackSay =
        {
            "Xem ngươi chạy đâu cho thoát",
            "Dám đánh nén ta à?",
            "Để xem các ngươi chạy đâu",
            "Đánh nén ta là điều không thể tha thứ"
        };

        private string[] FearSay =
        {
            "Mệt rồi!",
            "Ta cảm thấy mệt quá!",
            "Mệt quá! Nghỉ tí đã."
        };

        private string[] KillAttackSay =
        {
            "Để ta tiễn ngươi!",
            "Chết chắc rồi cưng à!",
            "Ngươi không chết mới là lạ.",
            "Ta sẽ ban tặng ngươi cái chết êm ái"
        };

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();

            ClearEffect();

            /*if(lastpowDamage > 0)
            {
                Body.CurrentDamagePlus = lastpowDamage;
                lastpowDamage = 0;
            }*/
            //Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;

            if (IsFear == false)
                Body.Config.IsShield = true;
            else
                Body.Config.IsShield = false;
        }

        public override void OnCreated()
        {
            base.OnCreated();
            IsFear = false;
            Body.CurrentDamagePlus = 1;
            m_currentPowDamage = 1;
        }

        public override void OnStartAttacking()
        {
            // check near player
            if (!IsFear)
            {
                bool result = false;

                foreach (Player player in Game.GetAllFightPlayers())
                {
                    if (player.IsLiving && player.X > Body.X - 200 && player.X < Body.X + 200)
                    {
                        result = true;
                    }
                }

                if (result)
                {
                    KillAttack(Body.X - 200, Body.X + 200);
                    return;
                }
            }

            if (m_attackTurn == 0)
            {
                if (!IsFear)
                {
                    // up power and call npc
                    Body.CallFuction(new LivingCallBack(PowerUpEffect), 2000);
                    if (((SimpleBoss)Body).CurrentLivingNpcNum <= 0)
                    {
                        Body.Say("Lửa địa ngục đâu, ra mau.", 0, 5000);
                        Body.CallFuction(new LivingCallBack(CallNpc), 7000);
                    }
                    else
                    {
                        Body.CallFuction(new LivingCallBack(AttackAllPlayer), 4000);
                    }
                }
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                if (!IsFear)
                {
                    // up power and attack near player
                    Body.CallFuction(new LivingCallBack(PowerUpEffect), 2000);
                    Body.CallFuction(new LivingCallBack(AttackPerson), 4000);
                    m_attackTurn++;
                }
                else
                {
                    m_attackTurn = 3;
                }
            }
            else if (m_attackTurn == 2)
            {
                if (!IsFear)
                {
                    // up power and attack all player
                    Body.CallFuction(new LivingCallBack(PowerUpEffect), 2000);
                    Body.CallFuction(new LivingCallBack(AttackAllPlayer), 4000);
                }
                m_attackTurn++;
            }
            else if (m_attackTurn == 3)
            {
                if (!IsFear)
                {
                    // up power and fear (only if not have any npc)
                    Body.CallFuction(new LivingCallBack(PowerUpEffect), 2000);
                    if (((SimpleBoss)Body).CurrentLivingNpcNum <= 0)
                    {
                        // fear
                        IsFear = true;
                        Body.Say("Hơ hơ... Ta bị ốm à??", 0, 2200);
                        Body.CallFuction(new LivingCallBack(ChangeAtoB), 4000);
                    }
                    else
                    {
                        Body.CallFuction(new LivingCallBack(JumpAndAttack), 4000);
                    }
                }
                else
                {
                    // wake up
                    IsFear = false;
                    m_currentPowDamage = 1;
                    Body.CallFuction(new LivingCallBack(ChangeBtoA), 2000);
                }
                m_attackTurn = 0;
            }
        }

        private void KillAttack(int fx, int tx)
        {
            lastpowDamage = Body.CurrentDamagePlus;

            Body.CurrentDamagePlus = 1000f;

            Body.ChangeDirection(Game.FindlivingbyDir(Body), 100);

            ((SimpleBoss)Body).RandomSay(KillAttackSay, 0, 2000, 0);
            Body.PlayMovie("beatC", 2000, 0); //3s
            Body.PlayMovie("beatE", 5000, 0);
            Body.RangeAttacking(fx, tx, "cry", 7000, null);
            Body.CallFuction(new LivingCallBack(SetState), 8000);
        }

        private void AttackPerson()
        {
            target = Game.FindNearestPlayer(Body.X, Body.Y);
            if (target != null)
            {
                Body.ChangeDirection(target, 100);
                Body.Say("Tên ranh kia hãy đỡ này!!!", 0, 1000);
                Body.PlayMovie("beatA", 1200, 0);

                ((PVEGame)Game).SendObjectFocus(target, 1, 3200, 0);
                Body.CallFuction(new LivingCallBack(CreateAttackEffect), 4000);
                if (Body.FindDirection(target) == -1)
                    Body.RangeAttacking(target.X - 50, Body.X, "cry", 4800, null);
                else
                    Body.RangeAttacking(Body.X, target.X + 50, "cry", 4800, null);
                Body.CallFuction(new LivingCallBack(SetState), 6000);
            }
        }

        private void AttackAllPlayer()
        {
            ((SimpleBoss)Body).RandomSay(AllAtackPlayerSay, 0, 1000, 0);
            Body.PlayMovie("beatB", 1000, 0);
            Body.RangeAttacking(Body.X - 10000, Body.X + 10000, "cry", 4100, null);
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                p.AddEffect(new ReduceStrengthEffect(1, m_reduceStreng), 4200);
            }
            Body.CallFuction(new LivingCallBack(SetState), 5000);
        }

        private void ChangeAtoB()
        {
            Body.PlayMovie("beatD", 1000, 0);
            ((SimpleBoss)Body).RandomSay(FearSay, 0, 4100, 0);
            Body.PlayMovie("AtoB", 4000, 0);
            Body.CallFuction(new LivingCallBack(SetState), 7000);
        }

        private void ChangeBtoA()
        {
            Body.PlayMovie("AtoB", 1000, 0);
            ((SimpleBoss)Body).RandomSay(SpecialAttackSay, 0, 2200, 0);
            Body.CallFuction(new LivingCallBack(JumpAndAttack), 2000);
        }

        private void JumpAndAttack()
        {
            target = Game.FindRandomPlayer();

            if (target != null)
            {
                Body.PlayMovie("jump", 500, 0);

                ((PVEGame)Game).SendObjectFocus(target, 1, 2000, 0);

                Body.BoltMove(target.X, target.Y, 2500);

                Body.PlayMovie("fall", 2600, 0);

                Body.RangeAttacking(target.X - 100, target.X + 100, "cry", 3000, null);

                Body.CallFuction(new LivingCallBack(SetState), 4000);
            }
        }

        private void PowerUpEffect()
        {
            m_currentPowDamage += m_perPowerUp;
            Body.CurrentDamagePlus = m_currentPowDamage;
            // power up
            m_powerUpEffect = ((PVEGame)Game).Createlayer(Body.X, Body.Y - 60, "", "game.crazytank.assetmap.Buff_powup", "", 1, 0);
        }

        private void CreateAttackEffect()
        {
            if (target != null)
            {
                m_effectAttack = ((PVEGame)Game).Createlayer(target.X, target.Y, "", "asset.game.4.blade", "", 1, 0);
            }
        }

        private void ClearEffect()
        {
            if (m_powerUpEffect != null)
                Game.RemovePhysicalObj(m_powerUpEffect, true);

            if (m_effectAttack != null)
                Game.RemovePhysicalObj(m_effectAttack, true);
        }
        private void CallNpc()
        {
            LivingConfig config = ((PVEGame)Game).BaseConfig();
            config.IsFly = true;

            for (int i = 0; i < m_totalNpc; i++)
            {
                int randX = Game.Random.Next(350, 1300);
                int randY = Game.Random.Next(100, 700);
                ((SimpleBoss)Body).CreateChild(npcId, randX, randY, true, config);
            }
        }

        private void RemoveAllNpc()
        {
            ((SimpleBoss)Body).RemoveAllChild();
        }

        private void SetState()
        {
            if (IsFear)
            {
                ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standB");
            }
            else
            {
                ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standA");
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
