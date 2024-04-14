from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from db import get_db_connection

router = APIRouter()

class User(BaseModel):
    uname: str
    email: str
    password: str

class UserDb(User):
    userid: str

class LoginInfos(BaseModel):
    email: str
    password: str

@router.post("/create")
async def create_user(user: User):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "INSERT INTO users (username, email, password) VALUES (%s, %s, %s) RETURNING user_id",
                (user.uname, user.email, user.password)
                )
        result = cursor.fetchall()
        user_id = result[0][0]
        user_db = user.dict()
        user_db['user_id'] = str(user_id)
        conn.commit()
        return {"user": user_db}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        conn.close()

@router.post("/login")
async def login_user(loginInfos: LoginInfos):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "SELECT * FROM users WHERE email=%s AND password=%s",
                (loginInfos.email, loginInfos.password)
                )
        result = cursor.fetchall()
        if len(result) != 0:
            user = result[0]
            print(user)
            res = {"user": {
                "user_id": str(user[0]),
                "username": user[1],
                "email": user[2],
                "password": user[3]
                }}
        else:
            raise HTTPException(status_code=404, detail="User not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        conn.close()
    return res

@router.post("/change")
async def change_user(user: UserDb):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "UPDATE users SET username=%s, email=%s, password=%s WHERE user_id=%s",
                (user.uname, user.email, user.password, user.userid)
                )
        conn.commit()
        return {"user": user.dict()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        conn.close()

@router.get("/all")
async def get_all_users():
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users")
        result = cursor.fetchall()
        return {"users": [{
                'user_id': u[0],
                'uname': u[1],
                'email': u[2],
                'password': u[3],
                } for u in result]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        conn.close()
