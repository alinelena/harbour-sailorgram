// This file generated by libqtelegram-code-generator.
// You can download it from: https://github.com/Aseman-Land/libqtelegram-code-generator
// DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN

#ifndef LQTG_FNC_USERS
#define LQTG_FNC_USERS

#include "telegramfunctionobject.h"
#include <QList>
#include "telegram/types/user.h"
#include "telegram/types/inputuser.h"
#include "telegram/types/userfull.h"

namespace Tg {
namespace Functions {

class LIBQTELEGRAMSHARED_EXPORT Users : public TelegramFunctionObject
{
public:
    enum UsersFunction {
        fncUsersGetUsers = 0xd91a548,
        fncUsersGetFullUser = 0xca30a5b1
    };

    Users();
    virtual ~Users();

    static bool getUsers(OutboundPkt *out, const QList<InputUser> &id);
    static QList<User> getUsersResult(InboundPkt *in);

    static bool getFullUser(OutboundPkt *out, const InputUser &id);
    static UserFull getFullUserResult(InboundPkt *in);

};

}
}

#endif // LQTG_FNC_USERS
