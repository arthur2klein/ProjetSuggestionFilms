from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()

class User(BaseModel):
    userid: str
    uname: str
    email: str
    password: str

class LoginInfos(BaseModel):
    email: str
    password: str

test_user = User(
    userid='0',
    uname='test',
    email='test@mail.com',
    password='tE5!tE5!'
)

@router.post("/create")
async def create_user(user: User):
    return {"user": user.dict()}

@router.post("/login")
async def login_user(loginInfos: LoginInfos):
    if (loginInfos.email == test_user.email and
        loginInfos.password == test_user.password):
        return {"user": test_user.dict()}
    else:
        raise HTTPException(status_code=404, detail="User not found")

@router.post("/change")
async def change_user(user: User):
    test_user.uname = user.uname
    test_user.email = user.email
    test_user.password = user.password
    return {"user": test_user.dict()}

@router.get("/all")
async def get_all_users():
    users = [
        User(
            userid=str(i),
            uname=f"name{i}",
            email=f"email{i}@test.com",
            password=f"password{i}"
            )
        for i in range(1, 18)
    ]
    return {"users": [user.dict() for user in users]}
