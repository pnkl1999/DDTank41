<?php

namespace Models;

use Illuminate\Database\Eloquent\Model;

class ServerList extends Model
{
    protected $table='Server_List';
    
    protected $primaryKey='ServerID';
    
    public $timestamps = false;
    
    protected $guarded = ['ServerID'];
}