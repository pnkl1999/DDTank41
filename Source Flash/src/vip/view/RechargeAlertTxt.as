package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import vip.data.VipSetting;
   
   public class RechargeAlertTxt extends Sprite implements Disposeable
   {
       
      
      private var _bg:DisplayObject;
      
      private var _title:FilterFrameText;
      
      private var _content:FilterFrameText;
      
      public function RechargeAlertTxt()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.vip.rechargeLVBg");
         addChild(this._bg);
         this._title = ComponentFactory.Instance.creat("VipRechargeLV.titleTxt");
         addChild(this._title);
         this._content = ComponentFactory.Instance.creat("VipRechargeLV.contentTxt");
         addChild(this._content);
      }
      
      public function set AlertContent(param1:int) : void
      {
         this._title.text = this.getAlertTitle(param1);
         this._content.text = this.getAlertTxt(param1);
         this._bg.height = 280;
      }
      
      private function getAlertTxt(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case 1:
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param0")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",VipSetting.expTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7",VipSetting.vipTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param1"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param2"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param3")) + "\n";
               break;
            case 2:
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param1")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",VipSetting.expTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7",VipSetting.vipTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param1"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param2"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param3")) + "\n";
               break;
            case 3:
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param1")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",VipSetting.expTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7",VipSetting.vipTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param1"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param2"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param3")) + "\n";
               break;
            case 4:
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param2")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",VipSetting.expTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7",VipSetting.vipTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param1"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param2"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param3")) + "\n";
               break;
            case 5:
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param2")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",VipSetting.expTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7",VipSetting.vipTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param1"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param2"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param3")) + "\n";
               break;
            case 6:
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param2")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",VipSetting.expTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7",VipSetting.vipTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param1"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param2"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param3")) + "\n";
               break;
            case 7:
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param2")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",VipSetting.expTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7",VipSetting.vipTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param1"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param2"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param3")) + "\n";
               break;
            case 8:
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param2")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",VipSetting.expTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7",VipSetting.vipTimesVIPRechargeArray[param1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param1"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param2"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param3")) + "\n";
               break;
            case 9:
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param2")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",VipSetting.expTimesVIPRechargeArray[param1 - 1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6Param")) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7",VipSetting.vipTimesVIPRechargeArray[param1 - 1]) + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param1"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param2"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8Param3")) + "\n";
         }
         return _loc2_;
      }
      
      private function getAlertTitle(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
               _loc2_ = LanguageMgr.GetTranslation("tank.vip.rechargeAlertTitle",param1 + 1);
               break;
            case 9:
               _loc2_ = LanguageMgr.GetTranslation("tank.vip.rechargeAlertEndTitle",param1);
         }
         return _loc2_;
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
            this._title = null;
         }
         if(this._content)
         {
            ObjectUtils.disposeObject(this._content);
            this._content = null;
         }
      }
   }
}
