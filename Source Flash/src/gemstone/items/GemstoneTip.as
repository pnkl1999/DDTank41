package gemstone.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import ddt.manager.LanguageMgr;
   import ddt.view.SimpleItem;
   import flash.display.DisplayObject;
   import gemstone.info.GemstoneStaticInfo;
   
   public class GemstoneTip extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _tempData:Object;
      
      private var _fiSoulName:FilterFrameText;
      
      private var _quality:SimpleItem;
      
      private var _type:SimpleItem;
      
      private var _attack:FilterFrameText;
      
      private var _defense:FilterFrameText;
      
      private var _agility:FilterFrameText;
      
      private var _luck:FilterFrameText;
      
      private var _grade1:FilterFrameText;
      
      private var _grade2:FilterFrameText;
      
      private var _grade3:FilterFrameText;
      
      private var _forever:FilterFrameText;
      
      private var _displayList:Vector.<DisplayObject>;
      
      public function GemstoneTip()
      {
         super();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._tempData = param1;
         if(!this._tempData)
         {
            return;
         }
         this._displayList = new Vector.<DisplayObject>();
         this.updateView();
      }
      
      private function clear() : void
      {
         var _loc1_:DisplayObject = null;
         while(numChildren > 0)
         {
            _loc1_ = getChildAt(0) as DisplayObject;
            if(_loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      private function updateView() : void
      {
         var txt:* = null;
         var gemstonTipItem:* = null;
         var obj:* = null;
         var i:int = 0;
         clear();
         _bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         _bg.width = 300;
         _bg.height = 200;
         this.tipbackgound = _bg;
         _fiSoulName = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
         _displayList.push(_fiSoulName);
         var temData:Vector.<GemstoneStaticInfo> = _tempData as Vector.<GemstoneStaticInfo>;
         var len:int = temData.length;
         var addAttackStr:String = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.GoldenAddAttack");
         var rdcDamageStr:String = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.GoldenReduceDamage");
         for(i = 0; i < len; )
         {
            if(temData[i].attack != 0)
            {
               obj = {};
               obj.id = temData[i].id;
               if(temData[i].level == 6)
               {
                  obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneAtc",String(temData[i].attack) + addAttackStr);
               }
               else
               {
                  obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstoneAtc",temData[i].level,String(temData[i].attack));
               }
               _fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstone");
               gemstonTipItem = new GemstonTipItem();
               gemstonTipItem.setInfo(obj);
               _displayList.push(gemstonTipItem);
            }
            else if(temData[i].defence != 0)
            {
               _fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstone");
               obj = {};
               obj.id = temData[i].id;
               if(temData[i].level == 6)
               {
                  obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneDef",String(temData[i].defence) + rdcDamageStr);
               }
               else
               {
                  obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstoneDef",temData[i].level,String(temData[i].defence));
               }
               gemstonTipItem = new GemstonTipItem();
               gemstonTipItem.setInfo(obj);
               _displayList.push(gemstonTipItem);
            }
            else if(temData[i].agility != 0)
            {
               _fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstone");
               obj = {};
               obj.id = temData[i].id;
               if(temData[i].level == 6)
               {
                  obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneAgi",String(temData[i].agility) + addAttackStr);
               }
               else
               {
                  obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstoneAgi",temData[i].level,String(temData[i].agility));
               }
               gemstonTipItem = new GemstonTipItem();
               gemstonTipItem.setInfo(obj);
               _displayList.push(gemstonTipItem);
            }
            else if(temData[i].luck != 0)
            {
               _fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstone");
               obj = {};
               obj.id = temData[i].id;
               if(temData[i].level == 6)
               {
                  obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneLuk",String(temData[i].luck) + rdcDamageStr);
               }
               else
               {
                  obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstoneLuk",temData[i].level,String(temData[i].luck));
               }
               gemstonTipItem = new GemstonTipItem();
               gemstonTipItem.setInfo(obj);
               _displayList.push(gemstonTipItem);
            }
            else if(temData[i].blood != 0)
            {
               _fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstone");
               obj = {};
               obj.id = temData[i].id;
               if(temData[i].level == 6)
               {
                  obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneHp",String(temData[i].blood) + rdcDamageStr);
               }
               else
               {
                  obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstoneLuk",temData[i].level,String(temData[i].blood));
               }
               gemstonTipItem = new GemstonTipItem();
               gemstonTipItem.setInfo(obj);
               _displayList.push(gemstonTipItem);
            }
            i++;
         }
         initPos();
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override protected function init() : void
      {
      }
      
      private function initPos() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = this._displayList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this._displayList[_loc2_].y = _loc2_ * 30 + 5;
            this._displayList[_loc2_].x = 5;
            addChild(this._displayList[_loc2_] as DisplayObject);
            _loc2_++;
         }
         if(this._displayList.length > 0)
         {
            this._bg.height = this._displayList[this._displayList.length - 1].y + 40;
         }
         else
         {
            this._bg.height = 40;
         }
      }
   }
}
