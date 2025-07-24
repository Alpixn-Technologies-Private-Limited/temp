package com.aipm.ai_project_management.modules.auth.security;

import com.aipm.ai_project_management.modules.auth.entity.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Objects;

public class UserPrincipal implements UserDetails {
    
    private User user;
    
    public UserPrincipal(User user) {
        this.user = user;
    }
    
    public static UserPrincipal create(User user) {
        return new UserPrincipal(user);
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    // Add this method
    public Long getId() {
        return user.getId();
    }
    
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return user.getAuthorities();
    }
    
    @Override
    public String getPassword() {
        return user.getPassword();
    }
    
    @Override
    public String getUsername() {
        return user.getUsername();
    }
    
    @Override
    public boolean isAccountNonExpired() {
        return user.isAccountNonExpired();
    }
    
    @Override
    public boolean isAccountNonLocked() {
        return user.isAccountNonLocked();
    }
    
    @Override
    public boolean isCredentialsNonExpired() {
        return user.isCredentialsNonExpired();
    }
    
    @Override
    public boolean isEnabled() {
        return user.isEnabled();
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        UserPrincipal that = (UserPrincipal) o;
        
        return Objects.equals(user, that.user);
    }
    
    @Override
    public int hashCode() {
        return user != null ? user.hashCode() : 0;
    }
    
    @Override
    public String toString() {
        return "UserPrincipal{" +
                "user=" + user +
                '}';
    }
}