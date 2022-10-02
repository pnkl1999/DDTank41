using Game.Logic.Actions;
using Game.Logic.Effects;
using Game.Logic.Phy.Actions;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Maths;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;

namespace Game.Logic.Phy.Object
{
	public class SimpleBomb : BombObject
	{
		private bool digMap;

		protected List<BombAction> m_actions;

		private bool m_bombed;

		protected bool m_controled;

		private BaseGame m_game;

		private BallInfo m_info;

		private float m_lifeTime;

		private Living m_owner;

		protected List<BombAction> m_petActions;

		protected int m_petRadius;

		protected double m_power;

		protected int m_radius;

		protected Tile m_shape;

		protected BombType m_type;

		protected int m_angle;

		public List<BombAction> Actions => m_actions;

		public BallInfo BallInfo => m_info;

		public bool DigMap => digMap;

		public float LifeTime => m_lifeTime;

		public Living Owner => m_owner;

		public List<BombAction> PetActions => m_petActions;

		public SimpleBomb(int id, BombType type, Living owner, BaseGame game, BallInfo info, Tile shape, bool controled, int angle)
			: base(id, info.Mass, info.Weight, info.Wind, info.DragIndex)
		{
			m_owner = owner;
			m_game = game;
			m_info = info;
			m_shape = shape;
			m_type = type;
			m_power = info.Power;
			m_radius = info.Radii;
			m_controled = controled;
			m_bombed = false;
			m_lifeTime = 0f;
			m_angle = Math.Abs(angle);
			m_petRadius = 80;
			if (m_info.IsSpecial())
			{
				digMap = false;
			}
			else
			{
				digMap = true;
			}
		}

		public void Bomb()
		{
			StopMoving();
			m_isLiving = false;
			m_bombed = true;
		}

		private void BombImp()
		{
			List<Living> playersAround = m_map.FindHitByHitPiont(GetCollidePoint(), m_radius);
			foreach (Living p3 in playersAround)
			{
				if (p3 is Player)
				{
					(p3 as Player).OnBeforeBomb((int)(m_lifeTime * 1000f) + 1000);
				}
				if (p3.IsNoHole || p3.NoHoleTurn)
				{
					p3.NoHoleTurn = true;
					if (!m_info.IsSpecial())
					{
						digMap = false;
					}
				}
				p3.SyncAtTime = false;
			}
			m_owner.SyncAtTime = false;
			try
			{
				if (digMap)
				{
					m_map.Dig(m_x, m_y, m_shape, null);
				}
				m_actions.Add(new BombAction(m_lifeTime, ActionType.BOMB, m_x, m_y, digMap ? 1 : 0, 0));
				switch (m_type)
				{
					case BombType.FORZEN:
						foreach (Living item2 in playersAround)
						{
							if (m_owner is SimpleBoss && new IceFronzeEffect(100).Start(item2))
							{
								m_actions.Add(new BombAction(m_lifeTime, ActionType.FORZEN, item2.Id, 0, 0, 0));
							}
							else if (m_owner is Player && !(item2 is Player) && item2.Config.DamageForzen)
							{
								item2.Properties2 = (int)item2.Properties2 - 1;
								if ((int)item2.Properties2 <= 0)
								{
									item2.PlayMovie("die", (int)Math.Round((m_lifeTime + 1f) * 1000f), 0);
									item2.Die((int)Math.Round((m_lifeTime + 1f) * 1000f));
								}
								else
								{
									item2.PlayMovie("cry", (int)Math.Round((m_lifeTime + 1f) * 1000f), 0);
								}
							}
							else if (item2 is SimpleNpc || item2 is Player || (item2 is SimpleBoss && item2.Config.IsHelper) || (item2 is SimpleBoss && item2.Config.CanFrost))
							{
								if (item2 is SimpleNpc && item2.Config.CanFrost)
								{
									m_actions.Add(new BombAction(m_lifeTime, ActionType.DO_ACTION, item2.Id, 0, 0, item2.DoAction));
									item2.IsFrost = true;
								}
								else if (new IceFronzeEffect(2).Start(item2))
								{
									m_actions.Add(new BombAction(m_lifeTime, ActionType.FORZEN, item2.Id, 0, 0, 0));
								}
								else
								{
									m_actions.Add(new BombAction(m_lifeTime, ActionType.FORZEN, -1, 0, 0, 0));
									m_actions.Add(new BombAction(m_lifeTime, ActionType.UNANGLE, item2.Id, 0, 0, 0));
								}
							}
							if ((item2 is SimpleBoss || item2 is SimpleNpc))// && TakeDamageFrozen(item2))
							{
								m_game.AddAction(new LivingAfterShootedFrozen(item2, (int)((m_lifeTime + 1f) * 1000f)));
							}
							if (item2.State == 1)
							{
								item2.SyncAtTime = true;
								item2.State = 0;
							}
						}
						break;
					case BombType.FLY:
						if (m_y > 10 && m_lifeTime > 0.04f)
						{
							if (!m_map.IsEmpty(m_x, m_y))
							{
								PointF point = new PointF(0f - base.vX, 0f - base.vY);
								point = point.Normalize(5f);
								m_x -= (int)point.X;
								m_y -= (int)point.Y;
							}
							m_owner.SetXY(m_x, m_y);
							m_owner.StartMoving();
							m_actions.Add(new BombAction(m_lifeTime, ActionType.TRANSLATE, m_x, m_y, 0, 0));
							m_actions.Add(new BombAction(m_lifeTime, ActionType.START_MOVE, m_owner.Id, m_owner.X, m_owner.Y, m_owner.IsLiving ? 1 : 0));
							(m_owner as Player).OnPlayerAnyShellThrow();
						}
						break;
					case BombType.CURE:
						using (List<Living>.Enumerator enumerator3 = playersAround.GetEnumerator())
						{
							while (enumerator3.MoveNext())
							{
								Living item3 = enumerator3.Current;
								double num = 0.0;
								if (m_map.FindPlayers(GetCollidePoint(), m_radius))
								{
									num = 0.4;
								}
								else
								{
									num = 1.0;
								}
								//num = 1.0;
								int num2 = 0;
								if (m_info.ID == 10009)
								{
									int num3 = (int)Math.Round(m_lifeTime);
									num2 = m_owner.PetEffects.AddBloodPercent * item3.MaxBlood / 100;
									if (num3 > 1)
									{
										num2 *= num3;
									}
									if (m_owner.Team == item3.Team)
									{
										item3.AddBlood(num2);
										((Player)item3).TotalCure += num2;
										m_actions.Add(new BombAction(m_lifeTime, ActionType.CURE, item3.Id, item3.Blood, num2, 0));
									}
									else
									{
										item3.AddBlood(-num2, 1);
										m_actions.Add(new BombAction(m_lifeTime, ActionType.KILL_PLAYER, item3.Id, num2, 1, item3.Blood));
									}
								}
								else
								{
									num2 = (int)((double)((Player)m_owner).PlayerDetail.SecondWeapon.Template.Property7 * Math.Pow(1.1, ((Player)m_owner).PlayerDetail.SecondWeapon.StrengthenLevel) * num);
									num2 += m_owner.FightBuffers.ConsortionAddBloodGunCount;
									num2 += m_owner.PetEffects.IncreaseAngelicPoint;
									if (item3 is Player)
									{
										((Player)item3).TotalCure += num2;
										item3.AddBlood(num2);
										m_actions.Add(new BombAction(m_lifeTime, ActionType.CURE, item3.Id, item3.Blood, num2, 0));
									}
									if ((item3 is SimpleBoss || item3 is SimpleNpc) && item3.Config.IsHelper)
									{
										if (m_game.BloodBuff > 0)
											num2 = m_game.BloodBuff;
										item3.AddBlood(num2);
										//item3.OnHeal(num2);
										item3.TotalCure += num2;
										m_actions.Add(new BombAction(m_lifeTime, ActionType.CURE, item3.Id, item3.Blood, num2, 0));
										m_game.AddAction(new LivingAfterHealAction(m_owner, item3, num2, (int)((m_lifeTime + 1f) * 1000f)));

									}
								}
								if (m_info.ID != 10009)
								{
									(m_owner as Player).OnPlayerShootCure();
								}
							(m_owner as Player).OnPlayerAnyShellThrow();
							}
						}
						break;
					default:
						{
							SimpleBoss friendlyBoss = null;
							bool isFront = true;
							int damage = 0;
							int critical = 0;
							foreach (Living p2 in playersAround)
							{
								if (m_owner.IsFriendly(p2) || (m_owner is Player && p2.Config.IsHelper) || (!(p2 is Player) && !p2.Config.CanTakeDamage))
								{
									continue;
								}
								if ((p2 is SimpleBoss || p2 is SimpleNpc) && (p2.Config.HaveShield || (p2.Config.BallCanDamage > 0 && p2.Config.BallCanDamage != m_info.ID)))
								{
									damage = 0;
								}
								m_game.AddAction(new LivingBeforeShootedAction(m_owner, p2, (int)((m_lifeTime + 0.5f) * 700f)));
								p2.OnMakeDamage(p2);
								damage = MakeDamage(p2);
								if (damage != 0)
								{
									critical = m_owner.MakeCriticalDamage(p2, damage);
									m_owner.OnTakedDamage(m_owner, ref damage, ref critical);
									if (p2.TakeDamage(m_owner, ref damage, ref critical, "Fire"))
									{
										isFront = false;
										//if ((p2 is SimpleBoss || p2 is SimpleNpc) && p2.Config.KeepLife && p2.Blood == 1)
										//{
										//	if (p2.DoAction >- 1)
										//		m_actions.Add(new BombAction(m_lifeTime, ActionType.DO_ACTION, p2.Id, 0, 0, 2));
										//}
										//else
										//{
										//	m_actions.Add(new BombAction(m_lifeTime, ActionType.KILL_PLAYER, p2.Id, damage + critical, (critical == 0) ? 1 : 2, p2.Blood));
										//}
										m_actions.Add(new BombAction(m_lifeTime, ActionType.KILL_PLAYER, p2.Id, damage + critical, (critical == 0) ? 1 : 2, p2.Blood));
										//pve
										if (p2 is SimpleBoss && (p2.Config.FriendlyBoss.ID != 0 && p2.Config.FriendlyBoss.CanShareDamage))
										{
											friendlyBoss = m_game.FindBossWithID(p2.Config.FriendlyBoss.ID);
											if (p2.Config.FriendlyBoss.ActionStr != "")
												p2.Config.FriendlyBoss.SetActionStr(friendlyBoss);
											if (friendlyBoss != null && friendlyBoss.ShareDamage(m_owner, ref damage, ref critical, "QuyDepTrai"))
											{
												m_actions.Add(new BombAction(m_lifeTime, ActionType.KILL_PLAYER, friendlyBoss.Id, damage + critical, (critical == 0) ? 1 : 2, friendlyBoss.Blood));
											}
										}
									}
									else
									{
										m_actions.Add(new BombAction(m_lifeTime, ActionType.UNFORZEN, p2.Id, 0, 0, 0));
									}
									if (m_owner is Player && p2 is SimpleBoss)
									{
										m_owner.TotalDameLiving += critical + damage;
									}
									if (p2 is Player)
									{
										int dander = ((Player)p2).Dander;
										if (m_owner.FightBuffers.ConsortionReduceDander > 0)
										{
											dander -= dander * m_owner.FightBuffers.ConsortionReduceDander / 100;
											((Player)p2).Dander = dander;
										}
										m_actions.Add(new BombAction(m_lifeTime, ActionType.DANDER, p2.Id, dander, 0, 0));
									}
									if (p2 is SimpleBoss || p2 is SimpleNpc)
									{
										((PVEGame)m_game).OnShooted();
										m_game.AddAction(new LivingAfterShootedAction(m_owner, p2, (int)((m_lifeTime + 1f) * 1000f)));
										if (p2.DoAction > -1)
										{
											//m_actions.Add(new BombAction(m_lifeTime, ActionType.DO_ACTION, p2.Id, 0, 0, p2.DoAction));
										}
									}
								}
								else if (damage == 0 && critical == 0)
								{
									if (p2 is SimpleBoss)
									{
										if (p2.DoAction > -1)
											m_actions.Add(new BombAction(m_lifeTime, ActionType.DO_ACTION, p2.Id, 0, 0, p2.DoAction));
									}
								}
								if (p2.IsLiving)
								{
									p2.StartMoving((int)((m_lifeTime + 1f) * 1000f), 12);
									m_actions.Add(new BombAction(m_lifeTime, ActionType.START_MOVE, p2.Id, p2.X, p2.Y, p2.IsLiving ? 1 : 0));
								}
								if (friendlyBoss != null && friendlyBoss.IsLiving)
								{
									friendlyBoss.StartMoving((int)((m_lifeTime + 1f) * 1000f), 12);
									m_actions.Add(new BombAction(m_lifeTime, ActionType.START_MOVE, friendlyBoss.Id, friendlyBoss.X, friendlyBoss.Y, friendlyBoss.IsLiving ? 1 : 0));
								}
								p2.SendAfterShootedAction((int)(((double)m_lifeTime + 1.0) * 1000.0));
							}
							List<Living> playerAroundForPet = m_map.FindHitByHitPiont(GetCollidePoint(), m_petRadius);
							if (!(m_owner is Player) || ((Player)m_owner).ShootCount != 1 || m_owner.PetEffects.PetBaseAtt == 0)
							{
								break;
							}
							if (playerAroundForPet.Count == 0)
							{
								m_petActions.Add(new BombAction(0f, ActionType.NULLSHOOT, 0, 0, 0, 0));
								break;
							}
							foreach (Living p in playerAroundForPet)
							{
								if (p.Config.HaveShield || (p.Config.KeepLife && p.Blood == 1) || (!(p is Player) && !p.Config.CanTakeDamage))
								{
									m_petActions.Add(new BombAction(0f, ActionType.NULLSHOOT, 0, 0, 0, 0));
								}
								else
								{
									if (p == m_owner)
									{
										continue;
									}
									damage = MakePetDamage(p, GetCollidePoint());
									if (damage <= 0)
									{
										continue;
									}
									damage = damage * m_owner.PetEffects.PetBaseAtt / 300;
									critical = m_owner.MakeCriticalDamage(p, damage);
									if (m_owner is Player)
									{
										m_owner.OnTakedPetDamage(m_owner, ref damage, ref critical);
									}
									m_owner.OnMakeDamage(m_owner, p, ref damage, ref critical);
									if (p.PetTakeDamage(m_owner, ref damage, ref critical, "PetFire"))
									{
										if (p is Player)
										{
											m_petActions.Add(new BombAction(m_lifeTime, ActionType.PET, p.Id, damage + critical, ((Player)p).Dander, p.Blood));
										}
										else
										{
											if (p is SimpleBoss && (p.Config.FriendlyBoss.ID != 0 && p.Config.FriendlyBoss.CanShareDamage))
											{
												friendlyBoss = m_game.FindBossWithID(p.Config.FriendlyBoss.ID);
												if (friendlyBoss != null && friendlyBoss.PetShareDamage(m_owner, ref damage, ref critical, "QuyDepTrai"))
												{
													m_petActions.Add(new BombAction(m_lifeTime, ActionType.PET, friendlyBoss.Id, damage + critical, 0, friendlyBoss.Blood));
												}
											}
											m_petActions.Add(new BombAction(m_lifeTime, ActionType.PET, p.Id, damage + critical, 0, p.Blood));
										}
									}
								}
							}
							break;
						}
				}
				Die();
			}
			finally
			{
				m_owner.SyncAtTime = true;
				foreach (Living item in playersAround)
				{
					item.SyncAtTime = true;
				}
			}
		}

		protected override void CollideGround()
		{
			base.CollideGround();
			Bomb();
		}

		protected override void CollideObjects(Physics[] list)
		{
			foreach (Physics physics in list)
			{
				physics.CollidedByObject(this);
				m_actions.Add(new BombAction(m_lifeTime, ActionType.PICK, physics.Id, 0, 0, 0));
			}
		}

		protected override void FlyoutMap()
		{
			m_actions.Add(new BombAction(m_lifeTime, ActionType.FLY_OUT, 0, 0, 0, 0));
			base.FlyoutMap();
		}

		protected int MakePetDamage(Living target, Point p)
		{
			if (!(target is Player) && (target.Config.HaveShield || !target.Config.CanTakeDamage || target.Config.IsHelper))
			{
				return 0;
			}
			double baseDamage = m_owner.BaseDamage;
			double baseGuard = target.BaseGuard;
			double defend = target.Defence;
			double attack = m_owner.Attack;
			if (target.AddArmor && (target as Player).DeputyWeapon != null)
			{
				int addPoint = (int)target.getHertAddition((target as Player).DeputyWeapon);
				baseGuard += (double)addPoint;
				defend += (double)addPoint;
			}
			if (m_owner.IgnoreArmor)
			{
				baseGuard = 0.0;
				defend = 0.0;
			}
			float damagePlus = m_owner.CurrentDamagePlus;
			float shootMinus = m_owner.CurrentShootMinus;
			double DR1 = 0.95 * (baseGuard - (double)(3 * m_owner.Grade)) / (500.0 + baseGuard - (double)(3 * m_owner.Grade));
			double DR2 = ((defend - m_owner.Lucky >= 0.0) ? (0.95 * (defend - m_owner.Lucky) / (600.0 + defend - m_owner.Lucky)) : (0.357 + defend * 1E-05));
			double DR3 = (double)m_owner.FightBuffers.WorldBossAddDamage * (1.0 - (baseGuard / 200.0 + defend * 0.003));
			double damage = (DR3 + baseDamage * (1.0 + attack * 0.001) * (1.0 - (DR1 + DR2 - DR1 * DR2))) * (double)damagePlus * (double)shootMinus;
			return (damage < 0.0) ? 1 : ((int)damage);
		}

		protected bool TakeDamageFrozen(Living target)
		{
			Point p = new Point(X, Y);
			if (target.Distance(p) < (double)m_radius)
			{
				return true;
			}
			return false;
		}

		protected int MakeDamage(Living target)
		{
			if ((!target.Config.CanTakeDamage || target.Config.HaveShield) && (target is SimpleBoss || target is SimpleNpc))
			{
				return 0;
			}
			double baseDamage = m_owner.BaseDamage;
			double baseGuard = target.BaseGuard;
			double defence = target.Defence;
			double attack = m_owner.Attack;
			if (target.AddArmor && (target as Player).DeputyWeapon != null)
			{
				int addPoint = (int)target.getHertAddition((target as Player).DeputyWeapon);
				baseGuard += (double)addPoint;
				defence += (double)addPoint;
			}
			if (m_owner.IgnoreArmor || target.Config.CancelGuard)
			{
				baseGuard = 0.0;
				defence = 0.0;
			}
			float damagePlus = m_owner.CurrentDamagePlus;
			float shootMinus = m_owner.CurrentShootMinus;
			double DR1 = 0.95 * (baseGuard - (double)(3 * m_owner.Grade)) / (500.0 + baseGuard - (double)(3 * m_owner.Grade));
			double DR2 = ((defence - m_owner.Lucky >= 0.0) ? (0.95 * (defence - m_owner.Lucky) / (600.0 + defence - m_owner.Lucky)) : 0.0);
			double DR3 = (double)m_owner.FightBuffers.WorldBossAddDamage * (1.0 - (baseGuard / 200.0 + defence * 0.003));
			double damage = (DR3 + baseDamage * (1.0 + attack * 0.001) * (1.0 - (DR1 + DR2 - DR1 * DR2))) * (double)damagePlus * (double)shootMinus;
			Point p = new Point(X, Y);
			double distance = target.Distance(p);
			if (distance < (double)m_radius)
			{
				damage *= 1.0 - distance / (double)m_radius / 4.0;
				if (m_owner is Player && target is Player && target != m_owner && target != m_owner)
				{
					int targetsDiferentes = 0;
					if ((m_owner.Direction == 1 && m_angle >= 91) || (m_owner.Direction == -1 && m_angle <= 89))
					{
						m_game.AddAction(new FightAchievementAction(m_owner, eFightAchievementType.EmperorOfPlayingBack, m_owner.AddedValueEffect++, 1200));
					}
					if (m_owner.lastShots.ContainsKey(target.Id))
					{
						m_owner.lastShots[target.Id]++;
					}
					else
					{
						m_owner.lastShots.Add(target.Id, 1);
					}
					if (m_owner.Prop1 >= 1 && m_owner.Prop2 >= 1 && m_owner.lastShots.ContainsKey(target.Id) && m_owner.lastShots[target.Id] >= 9)
					{
						m_game.AddAction(new FightAchievementAction(m_owner, eFightAchievementType.GodOfPrecision, m_owner.Direction, 1200));
					}
					foreach (int ids in m_owner.lastShots.Keys)
					{
						if (m_owner.lastShots[ids] >= 1)
						{
							targetsDiferentes++;
						}
					}
					if (targetsDiferentes >= 2)
					{
						m_game.AddAction(new FightAchievementAction(m_owner, eFightAchievementType.AcrobatMaster, m_owner.AddedValueEffect++, 1200));
					}
				}
				if (damage < 0.0)
				{
					return 1;
				}
				return (int)damage;
			}
			return 0;
		}

		public override void StartMoving()
		{
			base.StartMoving();
			m_actions = new List<BombAction>();
			m_petActions = new List<BombAction>();
			_ = m_game.LifeTime;
			while (m_isMoving && m_isLiving)
			{
				m_lifeTime += 0.04f;
				Point point = CompleteNextMovePoint(0.04f);
				MoveTo(point.X, point.Y);
				if (m_isLiving)
				{
					if (Math.Round(m_lifeTime * 100f) % 40.0 == 0.0 && point.Y > 0)
					{
						m_game.AddTempPoint(point.X, point.Y);
					}
					if (m_controled && base.vY > 0f)
					{
						Living living = m_map.FindNearestEnemy(m_x, m_y, 150.0, m_owner);
						if (living != null)
						{
							Point point2;
							if (!(living is SimpleBoss))
							{
								point2 = new Point(living.X - m_x, living.Y - m_y);
							}
							else
							{
								Rectangle dis = living.GetDirectDemageRect();
								point2 = new Point(dis.X - m_x + 20, dis.Y + dis.Height - m_y);
							}
							point2 = point2.Normalize(1000);
							setSpeedXY(point2.X, point2.Y);
							UpdateForceFactor(0f, 0f, 0f);
							m_controled = false;
							m_actions.Add(new BombAction(m_lifeTime, ActionType.CHANGE_SPEED, point2.X, point2.Y, 0, 0));
						}
					}
				}
				if (m_bombed)
				{
					m_bombed = false;
					BombImp();
				}
			}
		}
	}
}