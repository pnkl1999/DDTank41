package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class TofflistGridBox extends Sprite implements Disposeable
   {
       
      
      private var _resourceArr:Array;
      
      private var _styleLinkArr:Array;
      
      private var _gridBg:ScaleFrameImage;
      
      private var _gridBgIdArr:Array;
      
      private var _orderList:TofflistOrderList;
      
      public function TofflistGridBox()
      {
         super();
         this._gridBgIdArr = [1,2,1,4,1,5,6,5,5,4,3,4,3,8,7,8,8];
         this._gridBg = ComponentFactory.Instance.creatComponentByStylename("toffilist.GridBg");
         addChild(this._gridBg);
         this._orderList = new TofflistOrderList();
         this._orderList.y = 25;
         addChild(this._orderList);
      }
      
      public function get orderList() : TofflistOrderList
      {
         return this._orderList;
      }
      
      public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = this._resourceArr.length;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._resourceArr[_loc2_].dis;
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
            this._resourceArr[_loc2_] = null;
            _loc2_++;
         }
         this._resourceArr = null;
         this._styleLinkArr = null;
         this._gridBgIdArr = null;
         ObjectUtils.disposeAllChildren(this);
         this._gridBg = null;
         this._orderList = null;
      }
      
      public function set resourceLink(param1:String) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc6_:Object = null;
         this._resourceArr = [];
         var _loc3_:Array = param1.replace(/(\s*)|(\s*$)/g,"").split("|");
         var _loc4_:uint = 0;
         var _loc5_:uint = _loc3_.length;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = {};
            _loc6_.id = _loc3_[_loc4_].split("#")[0];
            _loc6_.className = _loc3_[_loc4_].split("#")[1];
            _loc2_ = ComponentFactory.Instance.creat(_loc6_.className);
            addChild(_loc2_);
            _loc6_.dis = _loc2_;
            this._resourceArr.push(_loc6_);
            _loc4_++;
         }
      }
      
      public function set setAllStyleXY(param1:String) : void
      {
         this._styleLinkArr = param1.replace(/(\s*)|(\s*$)/g,"").split("~");
         this.updateStyleXY(0);
      }
      
      public function updateStyleXY(param1:int = 0) : void
      {
         var _loc8_:Point = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc7_:int = 0;
         _loc8_ = null;
         var _loc5_:uint = this._resourceArr.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = this._resourceArr[_loc3_].dis;
            _loc2_.visible = false;
            _loc3_++;
         }
         var _loc6_:Array = this._styleLinkArr[param1].split("|");
         _loc5_ = _loc6_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = null;
            _loc7_ = _loc6_[_loc3_].split("#")[0];
            _loc4_ = 0;
            while(_loc4_ < this._resourceArr.length)
            {
               if(_loc7_ == this._resourceArr[_loc4_].id)
               {
                  _loc2_ = this._resourceArr[_loc4_].dis;
                  break;
               }
               _loc4_++;
            }
            if(_loc2_)
            {
               _loc8_ = new Point();
               _loc8_.x = _loc6_[_loc3_].split("#")[1].split(",")[0];
               _loc8_.y = _loc6_[_loc3_].split("#")[1].split(",")[1];
               _loc2_.x = _loc8_.x;
               _loc2_.y = _loc8_.y;
               _loc2_.visible = true;
            }
            _loc3_++;
         }
         this._gridBg.setFrame(this._gridBgIdArr[param1]);
      }
   }
}
