package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class TotemLeftWindowPropertyTxtView extends Sprite implements Disposeable
   {
       
      
      private var _levelTxtList:Vector.<FilterFrameText>;
      
      private var _txtArray:Array;
      
      public function TotemLeftWindowPropertyTxtView()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this._levelTxtList = new Vector.<FilterFrameText>();
         var _loc1_:int = 1;
         while(_loc1_ <= 7)
         {
            this._levelTxtList.push(ComponentFactory.Instance.creatComponentByStylename("totem.totemWindow.propertyName" + _loc1_));
            _loc1_++;
         }
         var _loc2_:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
         this._txtArray = _loc2_.split(",");
      }
      
      public function show(param1:Array) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         _loc2_ = 0;
         _loc2_ = 0;
         _loc2_ = 0;
         while(_loc2_ < 7)
         {
            this._levelTxtList[_loc2_].x = param1[_loc2_].x - 48;
            this._levelTxtList[_loc2_].y = param1[_loc2_].y + 22;
            addChild(this._levelTxtList[_loc2_]);
            _loc2_++;
         }
      }
      
      public function refreshLayer(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 7)
         {
            this._levelTxtList[_loc2_].text = LanguageMgr.GetTranslation("ddt.totem.totemWindow.propertyLvTxt",param1,this._txtArray[_loc2_]);
            _loc2_++;
         }
      }
      
      public function scaleTxt(param1:Number) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         _loc2_ = 0;
         if(!this._levelTxtList)
         {
            return;
         }
         var _loc3_:int = this._levelTxtList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this._levelTxtList[_loc2_].scaleX = param1;
            this._levelTxtList[_loc2_].scaleY = param1;
            this._levelTxtList[_loc2_].x -= 5;
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._levelTxtList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
