using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Bussiness;
namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.BAG_LOCKED, "二级密码")]
    public class PassWordTwoHandle : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            string msg = "BAG LOCK FAIL";
            bool result = false;
            int reType = 0;
            bool addInfo = false;
            int count = 0;
            byte cmd = 1;
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.BAG_LOCKED, client.Player.PlayerCharacter.ID);
            string passwordTwo = packet.ReadString();
            string passwordTwoNew = packet.ReadString();
            int type = packet.ReadInt();
            string passwordQuestion1 = packet.ReadString();
            string passwordAnswer1 = packet.ReadString();
            string passwordQuestion2 = packet.ReadString();
            string passwordAnswer2 = packet.ReadString();
            switch (type)
            {
                case 1:
                    {
                        reType = 1;
                        if (string.IsNullOrEmpty(client.Player.PlayerCharacter.PasswordTwo))
                            using (PlayerBussiness db = new PlayerBussiness())
                            {
                                if (passwordTwo != "")
                                {
                                    if (db.UpdatePasswordTwo(client.Player.PlayerCharacter.ID, passwordTwo))
                                    {
                                        client.Player.PlayerCharacter.PasswordTwo = passwordTwo;
                                        client.Player.PlayerCharacter.IsLocked = false;
                                        msg = "SetPassword.success";
                                    }
                                }
                                if (passwordQuestion1 != "" && passwordAnswer1 != "" && passwordQuestion2 != "" && passwordAnswer2 != "")
                                {

                                    if (db.UpdatePasswordInfo(client.Player.PlayerCharacter.ID, passwordQuestion1, passwordAnswer1, passwordQuestion2, passwordAnswer2, 5))
                                    {
                                        client.Player.PlayerCharacter.PasswordQuest1 = passwordQuestion1;
                                        client.Player.PlayerCharacter.PasswordQuest2 = passwordAnswer1;
                                        client.Player.PlayerCharacter.FailedPasswordAttemptCount = 5;
                                        result = true;
                                        addInfo = false;
                                        msg = "UpdatePasswordInfo.Success";
                                    }
                                    else
                                    {
                                        result = false;
                                    }
                                }
                                else
                                {
                                    result = true;
                                    addInfo = true;
                                }

                            }
                        else
                        {
                            msg = "SetPassword.Fail";
                            result = false;
                            addInfo = false;
                        }

                    }
                    break;
                case 2:
                    {
                        reType = 2;
                        if (passwordTwo == client.Player.PlayerCharacter.PasswordTwo)
                        {
                            client.Player.PlayerCharacter.IsLocked = false;
                            msg = "BagUnlock.success";
                            result = true;
                        }
                        else
                        {
                            msg = "PasswordTwo.error";
                            result = false;
                            addInfo = false;
                        }
                    }
                    break;

                case 3:
                    {
                        if (DateTime.Compare(client.Player.WaitingProcessor.AddSeconds(3.0), DateTime.Now) > 0)
                            return 1;
                        reType = 3;
                        using (PlayerBussiness db = new PlayerBussiness())
                        {
                            db.GetPasswordInfo(client.Player.PlayerCharacter.ID, ref passwordQuestion1, ref passwordAnswer1, ref passwordQuestion2, ref passwordAnswer2, ref count);
                            count--;
                            db.UpdatePasswordInfo(client.Player.PlayerCharacter.ID, passwordQuestion1, passwordAnswer1, passwordQuestion2, passwordAnswer2, count);

                            if (passwordTwo == client.Player.PlayerCharacter.PasswordTwo)
                            {

                                if (db.UpdatePasswordTwo(client.Player.PlayerCharacter.ID, passwordTwoNew))
                                {
                                    client.Player.PlayerCharacter.IsLocked = false;
                                    client.Player.PlayerCharacter.PasswordTwo = passwordTwoNew;
                                    msg = "UpdatePasswordTwo.Success";
                                    result = true;
                                    addInfo = false;
                                }
                                else
                                {
                                    msg = "UpdatePasswordTwo.Fail";
                                    result = false;
                                    addInfo = false;
                                }
                            }

                            else
                            {
                                msg = "PasswordTwo.error";
                                result = false;
                                addInfo = false;
                            }
                        }
                        client.Player.WaitingProcessor = DateTime.Now;
                    }
                    break;
                case 4:
                    {
                        if (DateTime.Compare(client.Player.WaitingProcessor.AddSeconds(3.0), DateTime.Now) > 0)
                            return 1;

                        reType = 4;
                        string dbPasswordAnswer1 = "";
                        string PassWordTwo = "";
                        string dbPasswordAnswer2 = "";
                        using (PlayerBussiness db = new PlayerBussiness())
                        {
                            db.GetPasswordInfo(client.Player.PlayerCharacter.ID, ref passwordQuestion1, ref dbPasswordAnswer1, ref passwordQuestion2, ref dbPasswordAnswer2, ref count);
                            count--;
                            db.UpdatePasswordInfo(client.Player.PlayerCharacter.ID, passwordQuestion1, passwordAnswer1, passwordQuestion2, passwordAnswer2, count);
                            if (dbPasswordAnswer1 == passwordAnswer1 && dbPasswordAnswer2 == passwordAnswer2 && dbPasswordAnswer1 != "" && dbPasswordAnswer2 != "")
                            {

                                if (db.UpdatePasswordTwo(client.Player.PlayerCharacter.ID, PassWordTwo))
                                {
                                    client.Player.PlayerCharacter.PasswordTwo = PassWordTwo;
                                    client.Player.PlayerCharacter.IsLocked = false;
                                    msg = "DeletePassword.success";
                                    result = true;
                                    addInfo = false;

                                }
                                else
                                {

                                    msg = "DeletePassword.Fail";
                                    result = false;
                                }
                            }
                            else
                            {
                                if (passwordTwo == client.Player.PlayerCharacter.PasswordTwo)
                                {
                                    if (db.UpdatePasswordTwo(client.Player.PlayerCharacter.ID, PassWordTwo))
                                    {
                                        client.Player.PlayerCharacter.PasswordTwo = PassWordTwo;
                                        client.Player.PlayerCharacter.IsLocked = false;

                                        msg = "DeletePassword.success";
                                        result = true;
                                        addInfo = false;
                                    }

                                }
                                else
                                {

                                    msg = "DeletePassword.Fail";
                                    result = false;
                                }
                            }
                        }
                        client.Player.WaitingProcessor = DateTime.Now;
                    }
                    break;

                case 5:
                    {
                        reType = 5;

                        if (client.Player.PlayerCharacter.PasswordTwo != null)
                        {
                            if (passwordQuestion1 != "" && passwordAnswer1 != "" && passwordQuestion2 != "" && passwordAnswer2 != "")
                            {
                                using (PlayerBussiness db = new PlayerBussiness())
                                {
                                    if (db.UpdatePasswordInfo(client.Player.PlayerCharacter.ID, passwordQuestion1, passwordAnswer1, passwordQuestion2, passwordAnswer2, 5))
                                    {
                                        result = true;
                                        addInfo = false;
                                        msg = "UpdatePasswordInfo.Success";
                                    }
                                    else
                                    {
                                        result = false;
                                    }
                                }
                            }
                        }
                    }
                    break;

            }

            pkg.WriteInt(client.Player.PlayerCharacter.ID);
            pkg.WriteInt(reType);
            pkg.WriteBoolean(result);
            pkg.WriteBoolean(addInfo);
            pkg.WriteString(LanguageMgr.GetTranslation(msg));
            pkg.WriteInt(count);
            pkg.WriteString(passwordQuestion1);
            pkg.WriteString(passwordQuestion2);
            //Console.WriteLine(" PasswordTwo {0}, count {1}, Type {2}", client.Player.PlayerCharacter.PasswordTwo, count, type);
            client.Out.SendTCP(pkg);
            return 0;
        }

    }


}
